Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010059.outbound.protection.outlook.com [52.101.84.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FA5242D97
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 15:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.59
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094030; cv=fail; b=SQGsxzyvJ8A+j/qE6AoHzGCrEEEUtRQOy6eJwCiVI3d53+v+e5tPs19XN4io7KRYz5RAMMUbGXcOp25pGhLoYcOvridXG5KqfBOhncQEIqtLwqgEQfFE1H5UZUCe1INB9s+i5dvmHxGQJCS+XMZry2+XYU2/TqOkGE9u4ev7wrI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094030; c=relaxed/simple;
	bh=YdGr2NGMN1S8B1KHTIr69MklJqpugk9XD3MvYG56jfw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TuTU0zZoucgdjoWGTSHOyLbOZZ25wMKYMTuqozwGMrSu9cz1SNxTh18CVK0F8nnGoEHYm0Tyyy0BpX8d2v8Awwb9Mg1RIHRlR6QV5Km2fzzCkCV743sLAC+kBfcJs410gwJ1d9QpNlK31EIFju//1UJ7W7Gdc3jQ/OBOxgNbhjI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HgqXWIqo; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HgqXWIqo; arc=fail smtp.client-ip=52.101.84.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HgqXWIqo";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HgqXWIqo"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ATUtTD5UY9LBUTNnRJC421xXhELXWBqK97o3XayT4VYXmSJ8fzinCB5EMxPAnhlpJ27R+bVgdq0cNim7WVWK2z9wWinmFOURBN1/gZ5dxu5/HKJpgQEcdoFDFGPVYtOV2AM8o2aakwEgW1IljX44vq8sLaK41jx0GMdv+b5umjw4zZElVpYy7DMbSr1WhmkL5f4j19gs7oKeGvrmBhLt6+ugwjOAZERnppKZNEEnGg2S5fwTATWip2gQvFqN4PdjG1yds1BXP/6xyKNXPHe/VDBZy77POlefVREkLiV1JIstbFVoI2Hg8bIwOthkohhkXHeGzwJTgenl5CKuVZKkDQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9RfLzFwP4PpBHoZM1v8LwtAW7nl981OoTdtKXWiw+b0=;
 b=qJv+gkb4476iQDWcJhU4gIZADUv0XfeE10Eds/iDErbzRKvTH1hjiGDCLmYlCWP3MBqHMESMRXPHrBZITfshKARXjupNTrV6SHrpgATGE1Lm37iUFp8QVh/8KfKyCkDFTHRk81Yds8QGI/88zL1iZa2EFenyxgsAea0HOJakZZ8PrHSQ0pFNqSImwBSh9QxvDrh+UFh61HoGBNbI81Bx4qOhg70wXn+whN/L0S8mFmZLr55HhpSpqaxd4VMAYWafWBSy04ojGerfcWgtvYxFFIQfdAQl+Ds2jkTv8ubq+FYaKNdqjBr9zabHxk2Qm1OqLCQ4shjMtZQKlfm6eTEQag==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RfLzFwP4PpBHoZM1v8LwtAW7nl981OoTdtKXWiw+b0=;
 b=HgqXWIqo5EST7gN2PhvJtsaBVeHFhASc7vBUTVPA+ywWAgsPiEPiP5Z5W8mTsER7T91ng4balSn4i1UYMQ1MvfNu290iWZ4aO19t5FT9tgMJ/ma8Riy+D6m5+eth4Z+1iEQ90F3r6GIr7lKABwPccO7eSRld5C8MGBRXz8SADaQ=
Received: from AS9PR04CA0132.eurprd04.prod.outlook.com (2603:10a6:20b:531::27)
 by GV2PR08MB8001.eurprd08.prod.outlook.com (2603:10a6:150:a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Fri, 3 Jul 2026
 15:53:39 +0000
Received: from AMS1EPF00000046.eurprd04.prod.outlook.com
 (2603:10a6:20b:531:cafe::97) by AS9PR04CA0132.outlook.office365.com
 (2603:10a6:20b:531::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 15:53:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000046.mail.protection.outlook.com (10.167.16.43) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 15:53:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xNBUtmQ2K0ui1Mq6mi2rvH7lTGb3cSXNi6eGX0hr+5Fv2udQHrTbPRUOQTihCg7E3prQva2nsnFDC6E9cRb4NDRbAhbF+zc6UVAbTO7DKJupMrIJULt3FiKcIUQ28Z9DtNXTcOHHaIo2PMiZmG9uoWh6DMcGNgI01OFgx/9fBxGq3BfhmslT3EvK71t9G7vYPvep5ExxeWU50NJMzQO8A9HJza+HyE9L86WXqbVQ3QUq40M8FPkbq4uHwSPjFey8QWBZz0ubhaH0joE3WWpqd3cgSWCIdRjdyME641MAslb0g3OJGSgZoR/H2aVrnc6g4gR2IqjDm9Vy2Q/D3RBOkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9RfLzFwP4PpBHoZM1v8LwtAW7nl981OoTdtKXWiw+b0=;
 b=eJClKweyPouDinHsrgz1u0SPRVgy2o1qnZu6ALA7cpo0B05aLo3LducshMkqlt0iIfgQCL2rE+R70iMTozmaMftmtCcUD8VWUlJtokpOwBDOjOoQC7fU9lWoqjgOd8BRqSAcayQ6CF/Snf50ziKSRQdGgjtoLv4p80qWEWqUl/swYm5wXpGGz8qAcbUfCiaC5Jav0eJjBOeQNrtwZkr+qs1J4jNyPVo/qM3nPmhCthrrJvo6BGqzG1I0uyFq9vbITTMa2twrW4JzgO1k5uIheMsolqe/IVHew71FITKcRUSd6W7tpnMVUKKC8K4C9b9nbYbkgE+wR2Nejgj+9r+c4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RfLzFwP4PpBHoZM1v8LwtAW7nl981OoTdtKXWiw+b0=;
 b=HgqXWIqo5EST7gN2PhvJtsaBVeHFhASc7vBUTVPA+ywWAgsPiEPiP5Z5W8mTsER7T91ng4balSn4i1UYMQ1MvfNu290iWZ4aO19t5FT9tgMJ/ma8Riy+D6m5+eth4Z+1iEQ90F3r6GIr7lKABwPccO7eSRld5C8MGBRXz8SADaQ=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by PAWPR08MB11014.eurprd08.prod.outlook.com (2603:10a6:102:46c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:52:36 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:52:36 +0000
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
Subject: [PATCH v3 04/40] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Thread-Topic: [PATCH v3 04/40] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Thread-Index: AQHdCwP3fPrpFxCDXE2WQ/GV5/9U3A==
Date: Fri, 3 Jul 2026 15:52:36 +0000
Message-ID: <20260703154811.3355680-5-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|PAWPR08MB11014:EE_|AMS1EPF00000046:EE_|GV2PR08MB8001:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ad1ed2f-b93f-4851-86e5-08ded91b3fac
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|38070700021|56012099006|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 SlsGjN4R9NQEF7HjS/4fGk89rJD/6NnnV241zcAEEO3UWsuTVvkNsAAVcoPxAfu9wua65ZzuJILrb7X8ILcVcuWOxFO/NJOyRGhfEJem8XZki+dTBMTlz4dU+a4Gmhpnfqg6mOswrqOnF1yWFPSneePL2lsLf1AOWDL3Jwq50PGpOcHVduKliF2X2gPESVw4O8sizR+ATm8NZPuw4rOsITgrK/w7DeQF1wXItRncivSb2vT7QVWZAthPW7ZtFOB791AT71Unt9SDl8u4hXTixHuui9jtpAVmkTsHSRF1wnL0yjuhrYORLHity0CcSZ5iFe0pEjRdnlpAtx32TBDgQKToLdSb+2LBRKCwZ53i4twVKacrvYGPfxl4HebbTPcdxLUzU5hJWcqW/nLNJ0egZ0LcETwtrk4NFN963u5zhg+4mZeySy20YWZeaG8MlqYiYVGSVlJ3/dE0L5moG+x/E5J14MjYozdnipoEnu9/JJ7MkqzKnTEIwjWSwmaiMJmKjGLRceiB9aO81jmyWUzUgMOgDjYCcTfQWOxktf1YU3F/8iQhvqFc9bneuxsfB4+tVNQX7WZNYWKhHl4VvmQ7P+zovbsrQHZwTdJKaJgnFdBurqrlQlRqeACJ6QQAN4oI0EIOTzrXR90acbQIYXTNWdaMOHwsSRQdZ5JlEkvdgWhqt9r2eOb793+8rsusDDfnYdBfvnIUqKT1tUf9Bkp96N6kKSkX8/YBT66E87nrtUA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(38070700021)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 MuQNlrMVvktdmt77CGA8qfy4mx5vVzy5fZ8gqyfJRrtVnWLd2zPVsBTuYoDqNmLixV0wDkFGZCwWGhyIQTfBz5dEcChjlAznwfIC6P8jDIlxkVvdH8EuKEoS/c/6Ge5WLEIXAb40w7q6BTmm0GEQyS0Xq7RcSmN7pCpm760tregtbRMErtBXeKykD4OfeoFkwGiuqTWqf6ymx+X9bs/bUJX85zVqBIjkMMFlZcs0RW9sZc8d0WDIAScPaz5QDcnpwDJEVKlpz4vkOFc4oyacFFTkONzPc1i6aHaRIa6l/ulFgHKqwvRNdPvbKgfLoLAmY+dIPsWBZey5rOzs6fXn8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11014
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000046.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e02a0a06-d492-4d58-cf2a-08ded91b1a5a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|1800799024|82310400026|35042699022|14060799003|18002099003|22082099003|11063799006|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	y0A7Za9pkY+1vGVCfkeGhX/i8gnI1HSlkpLqKdi509Cr0wRTU3BM2D4DaY0Vg/o3BNxYBjmbvrUSPLui0hwb+oHWKc750bkwRCmUDlR55Ln4kNNd1p1Wit+W6hKiktQs10fySAnR/Ib0v+sHFsoLPNeJgcyb9j6h6LcE+aaWAZhFdm+Iyg+MErqOnf4VPdcN3lIyfoQh8uiA+nW/0iVKicXwkBpH9iTYUpxVXC2imAT7mVynaZQQi9UuCJLZa7WWd2snFmxoA8qmdRV0X/pw8kyWo7zxn3uVt8L8kb2mF1+9znCyeKNS8Bt69RXOcqhk083E0AbbD5CjPqQDKuPBUxx9G23xY1+oR5tISc+IlMC+kDo6DkAAVuTZXQP+Kk/nEzC+o/+8Ijiqv1cJJ30TPyrwqzbVAhRKc6yJuENbsEvL4j4vhcpmdZpYnhwvtIVH3cWYDLwSZ023eIPEtYJN0q03i6E5ByS5IezhvHzgBvvQGE7f8nCEyF3JuuoRdf9ljXZz1bP16V4pP5rhOKRlabE22gxUSycpas09PyO3NzDxTspgUmOPeKn8SzkLA6/8fGZkTP5zpZzGmKtnS9X1Z5IKMBIqhkQ+TWj8UwIaLBW0r+JyJAB7xBtEglnSwCj4jYejIFJ8kGtbzQtLQM4DwNB+EGxHVC5H1OOMm/3wKNdsR29N4UC2dwM0V9HA1AUUhp3fE1cHVL42enDhr1BxJQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(1800799024)(82310400026)(35042699022)(14060799003)(18002099003)(22082099003)(11063799006)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JoglkUK2lXqExxqr79Pohx7jRAqD2D0nqH7MrmxshNFQBkz2cSwyh0O/GrubriZLcrpgtQbBAip/de9HgB+MpTJyab8WCh97CPziiWyom0n6JKQOXWCtZwz6S/+sQACtFVcPBLpxEJkFTzTbCkqfgkkCDSKoTu4a/2YNqyu37DVcrOfEjY4fw1n44dP2bJlnEqRQov3wKRamw4spzx+NuIztLN9o2JtZ+qv1qfQOxWZvt0ITtRq5VCaXv9RMkq+0vNQ8a8eH0blETEikUKhUPedFnxrYdarHkOYnBc+ZuV1y0kszAezBtCJLZrte86jWv1IcaW5QHYBDAyTMDIJjxOmt3o04ir0WqMHf0qDspAJOttm9LrG2JnJuuE2fy12g1EzSwrt1V+LUmfBe4DpxwBfCyp6091u7HnJri92faHJVMVNwmK7ecKloVbL3t+Wp
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 15:53:38.7714
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ad1ed2f-b93f-4851-86e5-08ded91b3fac
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8001

Complete the set of defined IRS MMIO registers in the GICv5 header
file. Up until now, the set of defined IRS MMIO registers has been
driven by code requirements. However, in order to properly emulate the
IRS MMIO interface in KVM, the full set of IRS MMIO registers needs to
be added.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 include/linux/irqchip/arm-gic-v5.h | 239 +++++++++++++++++++++++++++--
 1 file changed, 230 insertions(+), 9 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 681c5c51207d6..83cfcd056b250 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -62,20 +62,34 @@
 #define GICV5_OUTER_SHARE		0b10
 #define GICV5_INNER_SHARE		0b11
=20
+#define GICV5_AIDR_COMPONENT_IRS	0b00
+#define GICV5_AIDR_COMPONENT_ITS	0b01
+#define GICV5_AIDR_COMPONENT_IWB	0b10
+
+#define GICV5_AIDR_ARCH_MAJ_REV_V5	0
+#define GICV5_AIDR_ARCH_MIN_REV_V0	0
+
 /*
  * IRS registers and tables structures
  */
 #define GICV5_IRS_IDR0			0x0000
 #define GICV5_IRS_IDR1			0x0004
 #define GICV5_IRS_IDR2			0x0008
+#define GICV5_IRS_IDR3			0x000c
+#define GICV5_IRS_IDR4			0x0010
 #define GICV5_IRS_IDR5			0x0014
 #define GICV5_IRS_IDR6			0x0018
 #define GICV5_IRS_IDR7			0x001c
+#define GICV5_IRS_IIDR			0x0040
+#define GICV5_IRS_AIDR			0x0044
 #define GICV5_IRS_CR0			0x0080
 #define GICV5_IRS_CR1			0x0084
 #define GICV5_IRS_SYNCR			0x00c0
 #define GICV5_IRS_SYNC_STATUSR		0x00c4
+#define GICV5_IRS_SPI_VMR		0x0100
 #define GICV5_IRS_SPI_SELR		0x0108
+#define GICV5_IRS_SPI_DOMAINR		0x010c
+#define GICV5_IRS_SPI_RESAMPLER		0x0110
 #define GICV5_IRS_SPI_CFGR		0x0114
 #define GICV5_IRS_SPI_STATUSR		0x0118
 #define GICV5_IRS_PE_SELR		0x0140
@@ -85,11 +99,51 @@
 #define GICV5_IRS_IST_CFGR		0x0190
 #define GICV5_IRS_IST_STATUSR		0x0194
 #define GICV5_IRS_MAP_L2_ISTR		0x01c0
-
+#define GICV5_IRS_VMT_BASER		0x0200
+#define GICV5_IRS_VMT_CFGR		0x0210
+#define GICV5_IRS_VMT_STATUSR		0x0214
+#define GICV5_IRS_VPE_SELR		0x0240
+#define GICV5_IRS_VPE_DBR		0x0248
+#define GICV5_IRS_VPE_HPPIR		0x0250
+#define GICV5_IRS_VPE_CR0		0x0258
+#define GICV5_IRS_VPE_STATUSR		0x025c
+#define GICV5_IRS_VM_DBR		0x0280
+#define GICV5_IRS_VM_SELR		0x0288
+#define GICV5_IRS_VM_STATUSR		0x028c
+#define GICV5_IRS_VMAP_L2_VMTR		0x02c0
+#define GICV5_IRS_VMAP_VMR		0x02c8
+#define GICV5_IRS_VMAP_VISTR		0x02d0
+#define GICV5_IRS_VMAP_L2_VISTR		0x02d8
+#define GICV5_IRS_VMAP_VPER		0x02e0
+#define GICV5_IRS_SAVE_VMR		0x0300
+#define GICV5_IRS_SAVE_VM_STATUSR	0x0308
+#define GICV5_IRS_MEC_IDR		0x0340
+#define GICV5_IRS_MEC_MECID_R		0x0344
+#define GICV5_IRS_MPAM_IDR		0x0380
+#define GICV5_IRS_MPAM_PARTID_R		0x0384
+#define GICV5_IRS_SWERR_STATUSR		0x03c0
+#define GICV5_IRS_SWERR_SYNDROMER0	0x03c8
+#define GICV5_IRS_SWERR_SYNDROMER1	0x03d0
+
+#define GICV5_IRS_IDR0_IRSID		GENMASK(31, 16)
+#define GICV5_IRS_IDR0_SWE		BIT(12)
+#define GICV5_IRS_IDR0_MPAM		BIT(11)
+#define GICV5_IRS_IDR0_MEC		BIT(10)
+#define GICV5_IRS_IDR0_SETLPI		BIT(9)
+#define GICV5_IRS_IDR0_VIRT_ONE_N	BIT(8)
+#define GICV5_IRS_IDR0_ONE_N		BIT(7)
 #define GICV5_IRS_IDR0_VIRT		BIT(6)
+#define GICV5_IRS_IDR0_PA_RANGE		GENMASK(5, 2)
+#define GICV5_IRS_IDR0_INT_DOM		GENMASK(1, 0)
+
+#define GICV5_IRS_IDR0_INT_DOM_SECURE		0b00
+#define GICV5_IRS_IDR0_INT_DOM_NON_SECURE	0b01
+#define GICV5_IRS_IDR0_INT_DOM_EL3		0b10
+#define GICV5_IRS_IDR0_INT_DOM_REALM		0b11
=20
 #define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
 #define GICV5_IRS_IDR1_IAFFID_BITS	GENMASK(19, 16)
+#define GICV5_IRS_IDR1_PE_CNT		GENMASK(15, 0)
=20
 #define GICV5_IRS_IDR1_PRIORITY_BITS_1BITS	0b000
 #define GICV5_IRS_IDR1_PRIORITY_BITS_2BITS	0b001
@@ -105,13 +159,30 @@
 #define GICV5_IRS_IDR2_LPI		BIT(5)
 #define GICV5_IRS_IDR2_ID_BITS		GENMASK(4, 0)
=20
+#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(11), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(12), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(13), (r))
+
+#define GICV5_IRS_IDR3_VMT_LEVELS	BIT(10)
+#define GICV5_IRS_IDR3_VM_ID_BITS	GENMASK(9, 5)
+#define GICV5_IRS_IDR3_VMD_SZ		GENMASK(4, 1)
+#define GICV5_IRS_IDR3_VMD		BIT(0)
+
+#define GICV5_IRS_IDR4_VPE_ID_BITS	GENMASK(9, 6)
+#define GICV5_IRS_IDR4_VPED_SZ		GENMASK(5, 0)
+
 #define GICV5_IRS_IDR5_SPI_RANGE	GENMASK(24, 0)
 #define GICV5_IRS_IDR6_SPI_IRS_RANGE	GENMASK(24, 0)
 #define GICV5_IRS_IDR7_SPI_BASE		GENMASK(23, 0)
=20
-#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(11), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(12), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(13), (r))
+#define GICV5_IRS_IIDR_PRODUCT_ID	GENMASK(31, 20)
+#define GICV5_IRS_IIDR_VARIANT		GENMASK(19, 16)
+#define GICV5_IRS_IIDR_REVISION		GENMASK(15, 12)
+#define GICV5_IRS_IIDR_IMPLEMENTER	GENMASK(11, 0)
+
+#define GICV5_IRS_AIDR_COMPONENT	GENMASK(11, 8)
+#define GICV5_IRS_AIDR_ARCHMAJORREV	GENMASK(7, 4)
+#define GICV5_IRS_AIDR_ARCHMINORREV	GENMASK(3, 0)
=20
 #define GICV5_IRS_CR0_IDLE		BIT(1)
 #define GICV5_IRS_CR0_IRSEN		BIT(0)
@@ -134,21 +205,39 @@
=20
 #define GICV5_IRS_SYNC_STATUSR_IDLE	BIT(0)
=20
-#define GICV5_IRS_SPI_STATUSR_V		BIT(1)
-#define GICV5_IRS_SPI_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_SPI_VMR_VIRT		BIT_ULL(63)
+#define GICV5_IRS_SPI_VMR_VM_ID		GENMASK_ULL(15, 0)
=20
 #define GICV5_IRS_SPI_SELR_ID		GENMASK(23, 0)
=20
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN	GENMASK(1, 0)
+
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_SECURE	0b00
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_NON_SECURE	0b01
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_EL3	0b10
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_REALM	0b11
+
+#define GICV5_IRS_SPI_RESAMPLER_ID	GENMASK(23, 0)
+
 #define GICV5_IRS_SPI_CFGR_TM		BIT(0)
=20
+#define GICV5_IRS_SPI_CFGR_TM_EDGE	0b0
+#define GICV5_IRS_SPI_CFGR_TM_LEVEL	0b1
+
+#define GICV5_IRS_SPI_STATUSR_V		BIT(1)
+#define GICV5_IRS_SPI_STATUSR_IDLE	BIT(0)
+
 #define GICV5_IRS_PE_SELR_IAFFID	GENMASK(15, 0)
=20
+#define GICV5_IRS_PE_STATUSR_ONLINE	BIT(2)
 #define GICV5_IRS_PE_STATUSR_V		BIT(1)
 #define GICV5_IRS_PE_STATUSR_IDLE	BIT(0)
=20
 #define GICV5_IRS_PE_CR0_DPS		BIT(0)
=20
-#define GICV5_IRS_IST_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_IST_BASER_ADDR_MASK	GENMASK_ULL(55, 6)
+#define GICV5_IRS_IST_BASER_VALID	BIT_ULL(0)
+#define GICV5_IRS_IST_BASER_ADDR_SHIFT	6ULL
=20
 #define GICV5_IRS_IST_CFGR_STRUCTURE	BIT(16)
 #define GICV5_IRS_IST_CFGR_ISTSZ	GENMASK(8, 7)
@@ -166,15 +255,111 @@
 #define GICV5_IRS_IST_CFGR_L2SZ_16K	0b01
 #define GICV5_IRS_IST_CFGR_L2SZ_64K	0b10
=20
-#define GICV5_IRS_IST_BASER_ADDR_MASK	GENMASK_ULL(55, 6)
-#define GICV5_IRS_IST_BASER_VALID	BIT_ULL(0)
+#define GICV5_IRS_IST_STATUSR_IDLE	BIT(0)
=20
 #define GICV5_IRS_MAP_L2_ISTR_ID	GENMASK(23, 0)
=20
+#define GICV5_IRS_VMT_BASER_ADDR	GENMASK_ULL(55, 3)
+#define GICV5_IRS_VMT_BASER_ADDR_SHIFT	3ULL
+#define GICV5_IRS_VMT_BASER_VALID	BIT_ULL(0)
+
+#define GICV5_IRS_VMT_CFGR_STRUCTURE_TWO_LEVEL	0b1
+#define GICV5_IRS_VMT_CFGR_STRUCTURE_LINEAR	0b0
+
+#define GICV5_IRS_VMT_CFGR_STRUCTURE	BIT(16)
+#define GICV5_IRS_VMT_CFGR_VM_ID_BITS	GENMASK(4, 0)
+
+#define GICV5_IRS_VMT_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_VPE_SELR_S		BIT_ULL(63)
+#define GICV5_IRS_VPE_SELR_VPE_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VPE_SELR_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VPE_DBR_DBV		BIT_ULL(63)
+#define GICV5_IRS_VPE_DBR_REQ_DB	BIT_ULL(62)
+#define GICV5_IRS_VPE_DBR_DBPM		GENMASK_ULL(36, 32)
+#define GICV5_IRS_VPE_DBR_INTID	GENMASK_ULL(23, 0)
+
+#define GICV5_IRS_VPE_HPPIR_HPPIV	BIT_ULL(32)
+#define GICV5_IRS_VPE_HPPIR_TYPE	GENMASK_ULL(31, 29)
+#define GICV5_IRS_VPE_HPPIR_ID		GENMASK_ULL(23, 0)
+
+#define GICV5_IRS_VPE_CR0_DPS		BIT(0)
+
+#define GICV5_IRS_VPE_STATUSR_V		BIT(1)
+#define GICV5_IRS_VPE_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_VM_DBR_EN		BIT_ULL(63)
+#define GICV5_IRS_VM_DBR_VPE_ID		GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VM_SELR_VM_ID		GENMASK(15, 0)
+
+#define GICV5_IRS_VM_STATUSR_V		BIT(1)
+#define GICV5_IRS_VM_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_VMAP_L2_VMTR_M	BIT_ULL(63)
+#define GICV5_IRS_VMAP_L2_VMTR_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VMAP_VMR_M		BIT_ULL(63)
+#define GICV5_IRS_VMAP_VMR_U		BIT_ULL(62)
+#define GICV5_IRS_VMAP_VMR_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VMAP_VISTR_M		BIT_ULL(63)
+#define GICV5_IRS_VMAP_VISTR_U		BIT_ULL(62)
+#define GICV5_IRS_VMAP_VISTR_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VMAP_VISTR_TYPE	GENMASK_ULL(31, 29)
+
+#define GICV5_IRS_VMAP_L2_VISTR_M	BIT_ULL(63)
+#define GICV5_IRS_VMAP_L2_VISTR_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VMAP_L2_VISTR_TYPE	GENMASK_ULL(31, 29)
+#define GICV5_IRS_VMAP_L2_VISTR_ID	GENMASK_ULL(23, 0)
+
+#define GICV5_IRS_VMAP_VPER_M		BIT_ULL(63)
+#define GICV5_IRS_VMAP_VPER_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VMAP_VPER_VPE_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_SAVE_VMR_VM_ID	GENMASK_ULL(15, 0)
+#define GICV5_IRS_SAVE_VMR_Q		BIT_ULL(62)
+#define GICV5_IRS_SAVE_VMR_S		BIT_ULL(63)
+
+#define GICV5_IRS_SAVE_VM_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_SAVE_VM_STATUSR_Q	BIT(1)
+
+#define GICV5_IRS_MEC_IDR_MECIDSIZE	GENMASK(3, 0)
+
+#define GICV5_IRS_MEC_MECID_R_MECID	GENMASK(15, 0)
+
+#define GICV5_IRS_MPAM_IDR_HAS_MPAM_SP	BIT(24)
+#define GICV5_IRS_MPAM_IDR_PMG_MAX	GENMASK(23, 16)
+#define GICV5_IRS_MPAM_IDR_PARTID_MAX	GENMASK(15, 0)
+
+#define GICV5_IRS_MPAM_PARTID_R_IDLE	BIT(31)
+#define GICV5_IRS_MPAM_PARTID_R_MPAM_SP	GENMASK(25, 24)
+#define GICV5_IRS_MPAM_PARTID_R_PMG	GENMASK(23, 16)
+#define GICV5_IRS_MPAM_PARTID_R_PARTID	GENMASK(15, 0)
+
+#define GICV5_IRS_SWERR_STATUSR_IMP_EC	GENMASK_ULL(31, 24)
+#define GICV5_IRS_SWERR_STATUSR_EC	GENMASK_ULL(23, 16)
+#define GICV5_IRS_SWERR_STATUSR_OF	BIT_ULL(3)
+#define GICV5_IRS_SWERR_STATUSR_S1V	BIT_ULL(2)
+#define GICV5_IRS_SWERR_STATUSR_S0V	BIT_ULL(1)
+#define GICV5_IRS_SWERR_STATUSR_V	BIT_ULL(0)
+
+#define GICV5_IRS_SWERR_SYNDROMER0_VIRTUAL	BIT_ULL(63)
+#define GICV5_IRS_SWERR_SYNDROMER0_TYPE		GENMASK_ULL(62, 60)
+#define GICV5_IRS_SWERR_SYNDROMER0_ID		GENMASK_ULL(55, 32)
+#define GICV5_IRS_SWERR_SYNDROMER0_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_SWERR_SYNDROMER1_ADDR	GENMASK_ULL(55, 3)
+
 #define GICV5_ISTL1E_VALID		BIT_ULL(0)
+#define GICV5_IRS_ISTL1E_SIZE		8UL
=20
 #define GICV5_ISTL1E_L2_ADDR_MASK	GENMASK_ULL(55, 12)
=20
+#define GICV5_IRS_SETLPIR		0x0000
+#define GICV5_IRS_SETLPIR_ID		GENMASK(23, 0)
+
 /*
  * ITS registers and tables structures
  */
@@ -296,6 +481,42 @@
 #define GICV5_GSI_IWB_FRAME_ID			GENMASK(28, 16)
 #define GICV5_GSI_IWB_WIRE			GENMASK(15, 0)
=20
+/*
+ * CoreSight identification registers - ordered by increasing offset.
+ */
+#define GICV5_CORESIGHT_DEVARCH		0xffbc
+#define GICV5_CORESIGHT_PIDR4		0xffd0
+#define GICV5_CORESIGHT_PIDR5		0xffd4
+#define GICV5_CORESIGHT_PIDR6		0xffd8
+#define GICV5_CORESIGHT_PIDR7		0xffdc
+#define GICV5_CORESIGHT_PIDR0		0xffe0
+#define GICV5_CORESIGHT_PIDR1		0xffe4
+#define GICV5_CORESIGHT_PIDR2		0xffe8
+#define GICV5_CORESIGHT_PIDR3		0xffec
+#define GICV5_CORESIGHT_CIDR0		0xfff0
+#define GICV5_CORESIGHT_CIDR1		0xfff4
+#define GICV5_CORESIGHT_CIDR2		0xfff8
+#define GICV5_CORESIGHT_CIDR3		0xfffc
+
+#define GICV5_CORESIGHT_DEVARCH_VAL			\
+	(FIELD_PREP(GENMASK(31, 21), 0x23b) |		\
+	 BIT(20) |					\
+	 0x5a19)
+
+#define GICV5_CORESIGHT_PIDR4_JEP106_CONT	0x04
+#define GICV5_CORESIGHT_PIDR5_RES0		0x00
+#define GICV5_CORESIGHT_PIDR6_RES0		0x00
+#define GICV5_CORESIGHT_PIDR7_RES0		0x00
+#define GICV5_CORESIGHT_PIDR0_PART_0		0x4b
+#define GICV5_CORESIGHT_PIDR1_DES_0_PART_1	0xb0
+#define GICV5_CORESIGHT_PIDR2_DES_1		0x0b
+#define GICV5_CORESIGHT_PIDR3_REVAND_CMOD	0x00
+
+#define GICV5_CORESIGHT_CIDR0_VAL		0x0d
+#define GICV5_CORESIGHT_CIDR1_VAL		0xf0
+#define GICV5_CORESIGHT_CIDR2_VAL		0x05
+#define GICV5_CORESIGHT_CIDR3_VAL		0xb1
+
 /*
  * Global Data structures and functions
  */
--=20
2.34.1
