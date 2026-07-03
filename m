Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013004.outbound.protection.outlook.com [40.107.159.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D3D290DBB
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.4
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094635; cv=fail; b=VeVWZ6KwCosSP3BY92UzJeKSaVuPq+SsknFMN2UKUs1EN+FiAlF1YLEZsUh10KodsLOlaEfxoGUrY4sLXYWwfIfABNJxZmYXrT652ZCCd3fLAAZOEHXHxXcmvgMjYkNk8JtpEvbRuBpNq874z31XtPtTxhWgxGhWy3InIJQcmfI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094635; c=relaxed/simple;
	bh=tpVEUFWFo0N5gUA+T39KZP+mLbZEDCDrInv8mZxqHa8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BVipeGdpJin+fqHYPWOx+oIkg8RpWcD0PYK/fv7x6V/IddNEL8vDb0et4qr5OJDl2yiiWtCrGIcQ4/FK4z1eL2JmOLYcwNMOlQicveUjqJ5GPxs+4JV61XygBgpKs5KfYVCrpC7dSiEYAXQtBJPImG0mFaQENZxT99GmGxGSORM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GVSdFYzC; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GVSdFYzC; arc=fail smtp.client-ip=40.107.159.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GVSdFYzC";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GVSdFYzC"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qrzrURXSeCmmGoCGwlWvUgvl+YlgXtuJOGpEZ3BwcGpj8RAxPWw2wYiOIXNokhsaYjrPOhyuuv94PI9UPeHjOGCzNVhQaTDX+PKsdFCmNEh4WT9KCOJnY8rTXJVLnbOpEt7xJ5aT+wRK4HPw8V5b+6zy+lXXqgimAZkn0mAywhXlo1otyN6VV3NcUbs9CO9OE58D9I+iE4maLrZ8ZG9St+cytxl7BxLGfzpy7ARSls1pbXuE1UeTZI6pZHNLyHga45WXGJ4UEVvPOtOSC9p6QM/KZwuVfrbvYBQvcLUbbyqDy3Wods02uHnj9KGZ9uNGNrSaluy9LMtUYelS8Sy9kw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBBD/Qx2168rADX0pEGbPpmi2yUYpZf1u3sdvoFcLEQ=;
 b=F0gt6uj5L7oYRASrqK2ULXNga0DFYPNiK4+tlJ2VwQip9+6u1djOQj9bOJvLyQtpi60Oi2R20hbOfdRD2ybWXa8/Z0zw0opDEq72aG9mbWzODLCtmyI2K49frCSnXJaspb/M+0PXWwS8NOHz54wtMxK249A1kdYz2dSxb0UCFs1XhHAKbodWCAyT8XNAQjMJdEbwYMyuPkkHwXAX0i0mrwzLzNjD2yZM0KrI8eL3ZcORX7iG+rfdY9+1+BAPW5/1ASNzZ3rz+RpmzRy0LaqhZMwrN8es9+zyD71OqOaMtGh2DOeiZ0Zo9euW44evt4Bmw5eZSfsG1DqGY/pVLVJ6wA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBBD/Qx2168rADX0pEGbPpmi2yUYpZf1u3sdvoFcLEQ=;
 b=GVSdFYzCWGl6yE1TLHGwXTs4wjbunyzG4Y3iBQsdoCXoACTzmzCJQrzXyMrBMlBGbr1emYREdEkIBWhsgoxFAoZ5+FzZeuGUMNOJaqy/TphoMtaEoZFHzue1z/lWfSEwVODbPlirwEMhjPJxD7nUevvxkf/d5xaL+URaSjgPzDg=
Received: from DU2PR04CA0043.eurprd04.prod.outlook.com (2603:10a6:10:234::18)
 by DB3PR08MB8963.eurprd08.prod.outlook.com (2603:10a6:10:42b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Fri, 3 Jul 2026
 16:03:48 +0000
Received: from DU6PEPF0000A7E4.eurprd02.prod.outlook.com
 (2603:10a6:10:234:cafe::8e) by DU2PR04CA0043.outlook.office365.com
 (2603:10a6:10:234::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 16:03:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E4.mail.protection.outlook.com (10.167.8.43) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6 via
 Frontend Transport; Fri, 3 Jul 2026 16:03:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EcIcgtZimXlp7BTa7R2JEd8OSvCjH4ic1ZZcztGNC3xdAW4XgXebxUA0xAz2rCpHCDeGIyOEthT4yDaAJR14Zujb8HTvwR2KUfyYbNzxLOsmdOufb0I80w2AVc5grDOuQSbMlcllSBZ9FXTYxbdA1M54DSCh4hI87G726M5+1TBiTfgBoLxnc820+X/+knahOLKkaATWCRAApiIFAhfEvBe1QoVBxmV/V+EkcQK041TlxVKKCJb35s6YNrGJTy/siozc4q0P61iWQr+rfpO8GPoNAP6GKioaWBFskghge4ZYyIT55AGjqYX4owlbxkcA6eGNA04xCuoYuQPtbLfy2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBBD/Qx2168rADX0pEGbPpmi2yUYpZf1u3sdvoFcLEQ=;
 b=MH1sX03tquQwFfN4brNmioT8BaOawYx1/PvM4m3k6l5LJY6dnHxfwui2sUOf6hX3cmLlDCgOIb0Ylt1Ry9J2TxRckKdA46NRbV0X5zVP3fY2zvRD2unuEa9bZn9RhDqH3AH7mTWdXFqsRLwikNCGDOWkB2fIDFc4K9tS6Hn1zLp/JFQvx+EUVFSq/ClDc73cEMANhrblAwXnagsxwMvrN9HhlwZa4v52a8DbruDc9Xi2k58D7PdDsOXFS69rdoLnp2yb8EODaQElmZXJ6nTM0b65jAdwUvVYp2+AKJM0F+hdMl+H+XGaWg/AkK4YZQV4OXdfk4TaY+AVyoChfZSI2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBBD/Qx2168rADX0pEGbPpmi2yUYpZf1u3sdvoFcLEQ=;
 b=GVSdFYzCWGl6yE1TLHGwXTs4wjbunyzG4Y3iBQsdoCXoACTzmzCJQrzXyMrBMlBGbr1emYREdEkIBWhsgoxFAoZ5+FzZeuGUMNOJaqy/TphoMtaEoZFHzue1z/lWfSEwVODbPlirwEMhjPJxD7nUevvxkf/d5xaL+URaSjgPzDg=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by GV4PR08MB11250.eurprd08.prod.outlook.com (2603:10a6:150:2e9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:02:45 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:02:45 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v3 24/40] KVM: arm64: selftests: Update vGICv5 selftest to set
 IRS address
Thread-Topic: [PATCH v3 24/40] KVM: arm64: selftests: Update vGICv5 selftest
 to set IRS address
Thread-Index: AQHdCwViJ+AF3M2hCEeGoFFQolEt1Q==
Date: Fri, 3 Jul 2026 16:02:45 +0000
Message-ID: <20260703154811.3355680-25-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7310:EE_|GV4PR08MB11250:EE_|DU6PEPF0000A7E4:EE_|DB3PR08MB8963:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d4c206b-18df-4ea0-ea6f-08ded91caad0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|56012099006|11063799006|6133799003|18002099003|3023799007|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 pq2W7KozU8yCUbHy+X04r7UOyrUXAEA2MfOeSOQjZyPqSUZVMQwZ6UC1fOklXEjKb/V7dW+pxDJdu7O3gPL8lNzHWezRKz7990bpUNFxFx8poU0RRf3EqCP5OhuwLII6nLG78tPlDrE8xeXvFRUd1Q6Sw8XasJw7l5hfInenyS2Ixs6QGov5pdneIIgpW5LDkR6gOVJ3blDqEGq0LnrhjW8IqTb6aW3Mx7LpjOM02AlRNA4qQsGIZ3Ne/MPSrx2LbWIw2mxIvpoEWuLDwSy4J77OXION/u0/ObANL6esDAP8cf8q4bfMkT8w8F8FvRXzu7ufTyGS5agRTpKTLeE2DTZQswyTjPYA6D2Dl3+TJOmfwAStWu/kMzGfmTNoAg8+ieMVUHZ0gpMmtXSYYcWZFmTD4yA72sFLslwHhiGbx7sLUrTwRrGXwnghWojRxYa6aaxA05MuorHpe9m0oi7GIsjj7bdHX8D5GIY0R8Ki6scFQuidfICbVqcIkDCmYoPzi2fTdKyqXxZ05iCjhWGgBk4FQ2HiFtMzIBp/bC9fSLOgpR4CJC4JBvR+aU+vpBRE3g4ydK39T6Xd775/khUjear82SQMuTOxVPSOaKefU37yUkE6hb54dGfP8lEyDKvbwCkOfJwJNAwFWYa85EHS7h+QN349RLfypNEjUvBzh2dKW5k+PImJCz3ILLOg/tAsqVRXueUJ2RSt2vP1SC2LVoQgU7c6tbQdinpeHKCjdvI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(56012099006)(11063799006)(6133799003)(18002099003)(3023799007)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 T7nHdJ8XqfQZsnSjJrza4b4WzfnCtr7Cn+UQP2CXb2BGAsGaEZpxCngOKCvI8xBTcFLK77fNqcpfnNzRuKFKqMh6LnpgW4mthGWailDxGwZ8eFfCoZYi5j8p1ejg0hjsM+yPQA9HfmkRC1t6trAT0sEqiO5o9Ha6VnkHzK6Af5Ypwi+fd7Nmp8g8RDSxZWeXuK2tY15deieaztQW03B3TavKDHX6xIwKwEY44G6zmMjtklf2uKbv3Zw3EydGzeq0LITzCAshxejyuFIDh1x3KEMwOlKK76Z2jP1csJxy0visQHtWA8w562Hls72ah5ZXFJa+ioC0Ust+QL1ajUSr4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4PR08MB11250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7E4.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ca34808c-616b-4905-8576-08ded91c8577
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|35042699022|82310400026|14060799003|1800799024|36860700016|6133799003|11063799006|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	1ve5zjW+cR0+DaakJN5GMoAW2h6XOqwCDadIvnOT3R2sEqGT/z2u76BJNWMFfLbEwJczNJh4LphDuu10xK5LpxFtzlQv7oMkB2cy5oS+KPoEbBn9CdedB5QVuPH+BFLxT9uyBy0RxLNkfHzvhm2l+enXjsjt8Yi0YKdmzSR9VEDWnRDWzKLPexn3RPF/C+03qgNmsAjYkkBFzMfMZ6VTiFrjHSqjqI85K2bsDmLd6Hy5wSX3h/ox5iBKP7qiub8p3EvLThHvxh5YwzklApiVOBGKb5l5KMkbE8pNKWMLbFhQ+vGo+u4yF+mRTciErhXgDH7aU5jV4RUYPDZx/9j00UJs/PUSCZJ3SIcupYJCZCIdiBXth1PcFADuhKgvTQCtnT/vGqrOomdD5J+M3wW2lIBH4Xxy7p87lwMvMb9Ptgsbdm+In20kcBFqV63otlcrB0nTPdwTjuQzVvVio52pU4HDRl0Yolrt30LAuwsGPAhSMqPuBR4pPSJkVkNf4l8JJhYZ3B+QNv0fPzbzPMjUY1Ir9YLx9sMLpnsZa3RQwJnPEXhraBowV8Tbb3LTkK2WmjdDbX/ayGpvw38+y1sZMQPonZKCm3Oq3ZIU+jO8vLTtuXYZEjz/qcJQrrVkL1/cCKhnMn15VosUgn/lEYlYba5boOznXxUpDtlmyFgb5UB+nCVEEWbNgUK57My3wC9WQEmgX8cMq+oN8KHBF7wDSw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(35042699022)(82310400026)(14060799003)(1800799024)(36860700016)(6133799003)(11063799006)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	74GOdepe2zfdr2owOJeFtpE9/sRlFD7YBcemkXvjRUX0ykCoXl4MwGOr5im3YJ6iOofDyOSpf1WpPqspjdfv5fNc/HUprGE5zFfJ223VTmhySiAlZtpMw/6WNNUEcZEvKHkAsVXUeVJRgJ1+RaPxnrw/trXzJeKFoa+ssR3Khevn4rwOLVtg2sNBl3tRHbWtO8/mDUMer1JF5QNWa8pqzHoDOV+7EAjLIEKLDlR6dcQ3VqHkDeJVukmna8nR0hmgIocLglPj1pj7iRVQ1BBkfRkkZi4fOJvi0DTGcsRiDEVZ6DLL+wOjTejCdJeNhdudHXJl02isW+Mv9YrE4ynMUI2h4qBfo37ZC7VIwrhO48D+t89RLzGkmOGF14pTiKQjzv7Xhj7DM8/VJhg25kISKENkWZtfs1oWv9IatiZJvIVUFd7TlUM0FkLKTrwVhNhj
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:03:48.0227
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d4c206b-18df-4ea0-ea6f-08ded91caad0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E4.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB8963

This selftest was added before the GICv5 IRS was supported in
KVM. Therefore, there was no address to set, and the specific UAPI
didn't even exist.

Now that the IRS is supported, and setting its address is mandatory
before VGIC resources are mapped, set the emulated IRS GPA before
initialising the VGIC. Running a GICv5 VM will fail if userspace has
not provided the IRS address before the first vCPU run.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c        | 6 ++++++
 tools/testing/selftests/kvm/include/arm64/gic_v5.h | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index 96cfd6bb32f6f..19039a8940568 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -100,6 +100,7 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 	struct ucall uc;
 	u64 user_ppis[2];
 	struct vm_gic v;
+	uint64_t attr;
 	int ret, i;
=20
 	v.gic_dev_type =3D gic_dev_type;
@@ -116,6 +117,11 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 	for (i =3D 0; i < NR_VCPUS; i++)
 		vcpu_init_descriptor_tables(vcpus[i]);
=20
+	/* Set the address of the IRS before initialising the GIC */
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+
 	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
=20
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
index eb523d9277cf1..c388df8f2a2b4 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -10,6 +10,9 @@
=20
 #include "processor.h"
=20
+/* GIC component base address is guest PA space */
+#define GICV5_IRS_CONFIG_BASE_GPA	0x8000000ULL
+
 /*
  * Definitions for GICv5 instructions for the Current Domain
  */
--=20
2.34.1
