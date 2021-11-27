//
//  ShapeLayout+ScaleOptions.swift
//  PagingLayoutSamples
//
//  Created by Amir on 27/06/2020.
//  Copyright © 2020 Amir Khorsandi. All rights reserved.
//

import Foundation
import CollectionViewPagingLayout

extension ShapeLayout {
    var scaleOptions: ScaleTransformViewOptions? {
        switch self {
        case .scaleBlur:
            return ScaleTransformViewOptions(
                minScale: 0.8,
                scaleRatio: 0.4,
                translationRatio: CGPoint(x: 0.66, y: 0.2),
                maxTranslationRatio: CGPoint(x: 2, y: 0),
                blurEffectEnabled: true,
                blurEffectRadiusRatio: 0.04
               
               
            )
        case .scaleLinear:
            return ScaleTransformViewOptions(
                minScale: 0.8,
                scaleRatio: 0.4,
                translationRatio: CGPoint(x: 0.66, y: 0.2),
                maxTranslationRatio: CGPoint(x: 2, y: 0),
                keepVerticalSpacingEqual: false,
                keepHorizontalSpacingEqual: false,
                scaleCurve: .linear,
                translationCurve: .linear
            )
        case .scaleEaseIn:
            return ScaleTransformViewOptions(
                minScale: 0.6,
                scaleRatio: 0.4,
                translationRatio: CGPoint(x: 0.66, y: 0.2),
                keepVerticalSpacingEqual: true,
                keepHorizontalSpacingEqual: true,
                scaleCurve: .easeIn,
                translationCurve: .linear
            )
        case .scaleEaseOut:
            return ScaleTransformViewOptions(
                minScale: 0.6,
                scaleRatio: 0.4,
                translationRatio: CGPoint(x: 0.66, y: 0.2),
                keepVerticalSpacingEqual: true,
                keepHorizontalSpacingEqual: true,
                scaleCurve: .linear,
                translationCurve: .easeIn
            )
        case .scaleRotary:
            return ScaleTransformViewOptions(
                minScale: 0,
                scaleRatio: 0.4,
                translationRatio: CGPoint(x: 0.1, y: 0.1),
                minTranslationRatio: CGPoint(x: -1, y: 0),
                maxTranslationRatio: CGPoint(x: 1, y: 1),
                rotation3d: ScaleTransformViewOptions.Rotation3dOptions(angle: .pi / 15, minAngle: -.pi / 3, maxAngle: .pi / 3, x: 0, y: 0, z: 1, m34: -0.004),
                translation3d: .init(translateRatios: (0.9, 0.1, 0),
                                     minTranslateRatios: (-3, -0.8, -0.3),
                                     maxTranslateRatios: (3, 0.8, -0.3))
            )
        case .scaleCylinder:
            return ScaleTransformViewOptions(
                minScale: 0.55,
                maxScale: 0.55,
                scaleRatio: 0,
                translationRatio: .zero,
                minTranslationRatio: .zero,
                maxTranslationRatio: .zero,
                shadowEnabled: false,
                rotation3d: .init(angle: .pi / 4, minAngle: -.pi, maxAngle: .pi, x: 0, y: 1, z: 0, m34: -0.000_4 - 0.8 * 0.000_2 ),
                translation3d: .init(translateRatios: (0, 0, 0), minTranslateRatios: (0, 0, 1.25), maxTranslateRatios: (0, 0, 1.25))
            )
        case .scaleInvertedCylinder:
            return ScaleTransformViewOptions(
                minScale: 1.2,
                maxScale: 1.2,
                scaleRatio: 0,
                translationRatio: .zero,
                minTranslationRatio: .zero,
                maxTranslationRatio: .zero,
                shadowEnabled: false,
                rotation3d: .init(angle: .pi / 3, minAngle: -.pi, maxAngle: .pi, x: 0, y: -1, z: 0, m34: -0.002),
                translation3d: .init(translateRatios: (0.1, 0, 0),
                                     minTranslateRatios: (-0.05, 0, 0.86),
                                     maxTranslateRatios: (0.05, 0, -0.86))
            )
        case .scaleCoverFlow:
            return ScaleTransformViewOptions(
                minScale: 0.7,
                maxScale: 0.7,
                scaleRatio: 0,
                translationRatio: .zero,
                minTranslationRatio: .zero,
                maxTranslationRatio: .zero,
                shadowEnabled: true,
                rotation3d: .init(angle: .pi / 1.65, minAngle: -.pi / 3, maxAngle: .pi / 3, x: 0, y: -1, z: 0, m34: -0.000_5),
                translation3d: .init(translateRatios: (0.1, 0, -0.7), minTranslateRatios: (-0.1, 0, -3), maxTranslateRatios: (0.1, 0, 0))
            )
        default:
            return nil
        }
    }
}

extension ShapeLayout {
    var stackOptions: StackTransformViewOptions? {
        switch self {
        case .stackTransparent:
            return StackTransformViewOptions(
                scaleFactor: 0.12,
                minScale: 0.0,
                maxStackSize: 4,
                alphaFactor: 0.2,
                bottomStackAlphaSpeedFactor: 10,
                topStackAlphaSpeedFactor: 0.1,
                popAngle: .pi / 10,
                popOffsetRatio: .init(width: -1.45, height: 0.3)
            )
        case .stackPerspective:
            return StackTransformViewOptions(
                scaleFactor: 0.1,
                minScale: 0.2,
                maxStackSize: 6,
                spacingFactor: 0.08,
                alphaFactor: 0.0,
                perspectiveRatio: 0.3,
                shadowRadius: 5,
                popAngle: .pi / 10,
                popOffsetRatio: .init(width: -1.45, height: 0.3),
                stackPosition: CGPoint(x: 1, y: 0)
            )
        case .stackRotary:
            return StackTransformViewOptions(
                scaleFactor: -0.03,
                minScale: 0.2,
                maxStackSize: 3,
                spacingFactor: 0.01,
                alphaFactor: 0.1,
                shadowRadius: 8,
                stackRotateAngel: .pi / 16,
                popAngle: .pi / 4,
                popOffsetRatio: .init(width: -1.45, height: 0.4),
                stackPosition: CGPoint(x: 0, y: 1)
            )
        case .stackVortex:
            return StackTransformViewOptions(
                scaleFactor: -0.15,
                minScale: 0.2,
                maxScale: nil,
                maxStackSize: 4,
                spacingFactor: 0,
                alphaFactor: 0.4,
                topStackAlphaSpeedFactor: 1,
                perspectiveRatio: -0.3,
                shadowEnabled: false,
                popAngle: .pi,
                popOffsetRatio: .zero,
                stackPosition: CGPoint(x: 0, y: 1)
            )
        case .stackReverse:
            return StackTransformViewOptions(
                scaleFactor: 0.1,
                maxScale: nil,
                maxStackSize: 4,
                spacingFactor: 0.08,
                shadowRadius: 8,
                popAngle: -.pi / 4,
                popOffsetRatio: .init(width: 1.45, height: 0.4),
                stackPosition: CGPoint(x: -1, y: -0.2),
                reverse: true
            )
        case .stackBlur:
            return StackTransformViewOptions(
                scaleFactor: 0.1,
                maxScale: nil,
                maxStackSize: 7,
                spacingFactor: 0.06,
                topStackAlphaSpeedFactor: 0.1,
                perspectiveRatio: 0.04,
                shadowRadius: 8,
                popAngle: -.pi / 4,
                popOffsetRatio: .init(width: 1.45, height: 0.4),
                stackPosition: CGPoint(x: -1, y: 0),
                reverse: true,
                blurEffectEnabled: true,
                maxBlurEffectRadius: 0.08
            )
        default:
            return nil
        }
    }
}


extension ShapeLayout {
    var snapshotOptions: SnapshotTransformViewOptions? {
        switch self {
        case .snapshotGrid:
            return SnapshotTransformViewOptions(
                pieceSizeRatio: .init(width: 1.0 / 4.0, height: 1.0 / 10.0),
                piecesCornerRadiusRatio: .static(1),
                piecesAlphaRatio: .static(0),
                piecesTranslationRatio: .aggregated([.rowBasedMirror(CGPoint(x: 0, y: -1.8)), .columnBasedMirror(CGPoint(x: -1.8, y: 0))], +),
                piecesScaleRatio: .static(.init(width: 0.8, height: 0.8)),
                containerScaleRatio: 0.1,
                containerTranslationRatio: .init(x: 0.7, y: 0)
            )
        case .snapshotSpace:
            return SnapshotTransformViewOptions(
                pieceSizeRatio: .init(width: 1.0 / 3.0, height: 1.0 / 4.0),
                piecesCornerRadiusRatio: .static(0.7),
                piecesAlphaRatio: .aggregated([.rowBasedMirror(0.2), .columnBasedMirror(0.4)], +),
                piecesTranslationRatio: .aggregated([.rowBasedMirror(CGPoint(x: 1, y: -1)), .columnBasedMirror(CGPoint(x: -1, y: 1))], *),
                piecesScaleRatio: .static(.init(width: 0.5, height: 0.5)),
                containerScaleRatio: 0.1,
                containerTranslationRatio: .init(x: 0.7, y: 0)
            )
        case .snapshotChess:
            return SnapshotTransformViewOptions(
                pieceSizeRatio: .init(width: 1.0 / 5.0, height: 1.0 / 10.0),
                piecesCornerRadiusRatio: .static(0.5),
                piecesAlphaRatio: .columnBasedMirror(0.4),
                piecesTranslationRatio: .columnBasedMirror(CGPoint(x: -1, y: 1)),
                piecesScaleRatio: .static(.init(width: 0.5, height: 0.5)),
                containerScaleRatio: 0.1,
                containerTranslationRatio: .init(x: 0.7, y: 0)
            )
        case .snapshotTiles:
            return SnapshotTransformViewOptions(
                pieceSizeRatio: .init(width: 1, height: 1.0 / 10.0),
                piecesCornerRadiusRatio: .static(0),
                piecesAlphaRatio: .static(0.4),
                piecesTranslationRatio: .rowOddEven(CGPoint(x: -0.4, y: 0), CGPoint(x: 0.4, y: 0)),
                piecesScaleRatio: .static(.init(width: 0, height: 0.1)),
                containerScaleRatio: 0.1,
                containerTranslationRatio: .init(x: 1, y: 0)
            )
        case .snapshotLines:
            return SnapshotTransformViewOptions(
                pieceSizeRatio: .init(width: 1, height: 1.0 / 16.0),
                piecesCornerRadiusRatio: .static(0),
                piecesAlphaRatio: .static(0.4),
                piecesTranslationRatio: .rowOddEven(CGPoint(x: -0.15, y: 0), CGPoint(x: 0.15, y: 0)),
                piecesScaleRatio: .static(.init(width: 0.6, height: 0.96)),
                containerScaleRatio: 0.1,
                containerTranslationRatio: .init(x: 0.8, y: 0)
            )
        case .snapshotBars:
            return SnapshotTransformViewOptions(
                pieceSizeRatio: .init(width: 1.0 / 10.0, height: 1),
                piecesCornerRadiusRatio: .static(1.2),
                piecesAlphaRatio: .static(0.4),
                piecesTranslationRatio: .columnOddEven(CGPoint(x: 0, y: -0.1), CGPoint(x: 0, y: 0.1)),
                piecesScaleRatio: .static(.init(width: 0.2, height: 0.6)),
                containerScaleRatio: 0.1,
                containerTranslationRatio: .init(x: 1, y: 0)
            )
        case .snapshotPuzzle:
            return SnapshotTransformViewOptions(
                pieceSizeRatio: .init(width: 1.0 / 4.0, height: 1.0 / 10.0),
                piecesCornerRadiusRatio: .static(0),
                piecesAlphaRatio: .aggregated([.rowOddEven(0.2, 0), .columnOddEven(0, 0.2)], +),
                piecesTranslationRatio: .rowOddEven(CGPoint(x: -0.15, y: 0), CGPoint(x: 0.15, y: 0)),
                piecesScaleRatio: .columnOddEven(.init(width: 0.1, height: 0.4), .init(width: 0.4, height: 0.1)),
                containerScaleRatio: 0.2,
                containerTranslationRatio: .init(x: 1, y: 0)
            )
        case .snapshotFade:
            return SnapshotTransformViewOptions(
                pieceSizeRatio: .init(width: 1, height: 1.0 / 10.0),
                piecesCornerRadiusRatio: .static(0.1),
                piecesAlphaRatio: .rowBased(0.1),
                piecesTranslationRatio: .rowBasedMirror(CGPoint(x: 0, y: 0.1)),
                piecesScaleRatio: .rowBasedMirror(.init(width: 0.05, height: 0.1)),
                containerScaleRatio: 0.7,
                containerTranslationRatio: .init(x: 1.9, y: 0)
            )
        default:
            return nil
        }
        
    }
}
