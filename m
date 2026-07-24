Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013049.outbound.protection.outlook.com [52.101.83.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A88E42A173
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.49
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890686; cv=fail; b=n2FR+0e0EULPmTONUk4I8+HhbeH1R/7DsGx2DJiBWnS3vjp1OY99FHjH4wG91qrhuD/Ok4kDUjLD2KSD9sgeyBa/DeLUE7scnbeOFsAc1xMaKrj5Ui8/D37OzeJpj4UfUmRkusxXOirarbLlrkqhCl1ItAfjKvDG51mgmfBownc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890686; c=relaxed/simple;
	bh=pczKoaWSL7oYeOVUdcktirfYF72f4jSeLuUI4FrL8ac=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R4+AYu+F4YtWt/05kWcsGkqaUfOIm4NFJNXxF1OKJ/5GPlrs2kbiXvRrRGdtVgv1ze9EuS9s8dWytaCEYk2ZbMoihjCuLbvxBNjZMatkmNZXnlkAkv2fHFX4rZrdNU01sjVfbMlZnDOK+tZJDpahrW01vjuSes5dkEOtDj8K2mc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=E9bU9n+G; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=E9bU9n+G; arc=fail smtp.client-ip=52.101.83.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="E9bU9n+G";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="E9bU9n+G"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=UbSC2deSbDDhSawpSIM+SqQdAFQr0JHgzkchbfLHPUgIdn+dU+HlIGdmqMDhfAzAFl2V13vw1WGWDZhjuthOQuCTsu03bCiUsemBQwUqUzMtS1sZLuRLK8gy8Wc8fXwX8le2rZRjgL8pBiIsXbvZJ+YzDHbzxZyBVfb41f+nr27hbbPi6ilNwV0kKveln1aJlOqOS1RuAhDpbc/rg8afVh9TbSjB2+CWWFRr0qrYGFaImSIn+7g3xPqcjVzz7HrK5A2opdw75d0MoH3UMeZvdPmrXFi3u5syM68XCrmmTvf7VrUir11KQMVHx++oKpLkvJmUNH61aL7fLizbYMV4Cw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9r2XB0yL2EJZ4Fk5liZ2LwYOxf2WSUt97uiVD/o/yMg=;
 b=yB4LvfHx/efGXcwWHlJ7/AJ+3gZG+ybDKPITNMGcNzs8HCJEjidBMxNLkH+EsPmOIol9ZSBScxeNp1v2An14sNM89d6t3JXpGezBE70sh5QvBbKhpPJdsaVndPqa5Ix2sIJNrpcSW4xDgN0kv98Ru6cbvQDlpsmnkQCAcDvu4TTIyjcmyT2VSbO3RaJ3ND4mFBZGVREeE9r/wzkCIMAgrjtB4O9s/fyQ0d4ojwzjjduDHF5CfEKA/hRICqhieqyQhHNKLOLIRYP+YGjNhDeuEdt8gErHJqh6fB2U/mR6TAfZc3W3/OBje+1mSeMRQ/MsyZO5YCFpqF/hZg1e2sshSQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9r2XB0yL2EJZ4Fk5liZ2LwYOxf2WSUt97uiVD/o/yMg=;
 b=E9bU9n+GzFg+PHsw58GY1ndP/nL5R2ucmLjfEPYJVys4zrIdxqetNv4fzsLEF/OSznp8kuV0Xc+Am3QKoljrQrR1foLvTYz67xyzng0QdwhzBzxKiLIoof0CURi7u2uwK3mE5dwfZbN5gqaLmLhSb34lZZNLStbWXTL4xlefaXI=
Received: from DUZPR01CA0239.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b5::28) by VI1PR08MB5309.eurprd08.prod.outlook.com
 (2603:10a6:803:133::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Fri, 24 Jul
 2026 10:57:58 +0000
Received: from DB1PEPF000509FC.eurprd03.prod.outlook.com
 (2603:10a6:10:4b5:cafe::ab) by DUZPR01CA0239.outlook.office365.com
 (2603:10a6:10:4b5::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:57:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FC.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.5
 via Frontend Transport; Fri, 24 Jul 2026 10:57:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qdmod5fgvNxzVTnkxvPnXzrxNleMNgPbfKsgAUhQrplY1dm3rPtK6oZC+sybu15izFqDf93hveAjvqtb9BwDTVNtQuMZeki8YeBn6fvOq76npX7mS9W0aI+wdWquWVbVVxEq7TkOcrNn1dnyKjHhud/UIpPi/4uOdM7xI95RAOVetqhFlfMEf59nqGvQQO4xcXDpuzWWvt4PFnE7RB0glSvSiKdmynglwA13RsIvEAGjlAgwTLqC8YStKYENeByJgmY4K5u9+t+pW6XAWVx2h0VNkUNA9EWzLpYMksP77WcDGR5zqsvZ2gLc5e2qt6ZatpYuI7OaGRiF5Aqj4StVlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9r2XB0yL2EJZ4Fk5liZ2LwYOxf2WSUt97uiVD/o/yMg=;
 b=zIpQdqHOgJ+DELDZ+jLfOTFlwUI/JseuV3UZc/HT95erRPGLTTVgVSaCOr6v9tKDGdN8Me0K7wnpx2882gjyrA1KsLNyx+Cr5Aq42Y33sbMR3aycIhqP1WjAXw4zaIjYwKQDGtnO2Z2Mb+4QP+6SV7eCuHPEpv3J74zm7hy7jiEFwcCcgVZSQkzFVa2rIon4ev26BE6/2pLbTaccBRwPgGXy7tTWS3xbMfZK4Bgy0DHwW7Baq22PalmZ1SvPWPrpLXH3Rpn/fazgV5bu3+IVb+AqCQxWFZnNm6jU8oiHBssPpDAiaKiaQlNmzZBMVfSytpXi16hI3kaWOMcgjzP1bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9r2XB0yL2EJZ4Fk5liZ2LwYOxf2WSUt97uiVD/o/yMg=;
 b=E9bU9n+GzFg+PHsw58GY1ndP/nL5R2ucmLjfEPYJVys4zrIdxqetNv4fzsLEF/OSznp8kuV0Xc+Am3QKoljrQrR1foLvTYz67xyzng0QdwhzBzxKiLIoof0CURi7u2uwK3mE5dwfZbN5gqaLmLhSb34lZZNLStbWXTL4xlefaXI=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DB9PR08MB7769.eurprd08.prod.outlook.com (2603:10a6:10:395::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:56:55 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:56:55 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v4 33/48] KVM: arm64: gic-v5: Add CoreSight MMIO regs to IRS
Thread-Topic: [PATCH v4 33/48] KVM: arm64: gic-v5: Add CoreSight MMIO regs to
 IRS
Thread-Index: AQHdG1sjpub0yfRv0Uuc/5oXAKAauA==
Date: Fri, 24 Jul 2026 10:56:54 +0000
Message-ID: <20260724104819.1296803-34-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DB9PR08MB7769:EE_|DB1PEPF000509FC:EE_|VI1PR08MB5309:EE_
X-MS-Office365-Filtering-Correlation-Id: 06b69a3b-d9c0-406b-2fd8-08dee9726c02
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 WSRK9Ts1+36BmnFmtY622dblnrVm39ysJ8PcP6YuBI9/8OpXQabjeVZkjvcnRKgNop4B2nOdSAuYk6PSzK/oMlU4yc5OKgmXgQogiVd5ee16zU8mYu6KWUhhvshWUTEZt0wsmGU2m7sfeVk46LedyICAEXOCSL7iLDIvwP8diF+8YBAsWx41vfzzN9puQjXXYWTL27Kx/8FofMKbB3BHzBmn9G2JYmA1Qn/NzHcMHglAjmmfD3I1MnhyZqsSjPMDw3ADvsvqWrVqYnkkINyeLm6kUpH4jJdx9DfNLwOFqJmrSrGaTzDyQGD8lszNAydluRP75Cp87JlvIdqgXwJTnl/UcbQqgSm1VFuQauh8TfqI/zZe2N63oZ31hX2qo6ROeCkiwEn+Nzqgc7P4BjS+Z1TbcnhFEvux/WzAdSWIkSVw+917pIxZqxCLz8zf3bwAhqhE/JcPDmXP2LLrjZPOr1WESFQTDq9Em9m5/bKlb8WkoXyQR7gewGiUI2731uTw1Saw3zgcd6EdO/UWEuabdn/YucIyIHn+gnycjSyL6Yt2SUI5Tw+EYa3rzBUWDzDGiatRWXypjQqq4p3BeI+0//L/R59iZXwffSSnwJp9rwx7/sjPWTpg4nar9mUYr44o259oftpn0piNH7fR7uinfEsx8pSzLkMwaBGFnxV2/M6H+Q1FNEeF5B9HqyxgfHUSicwegsvuijCoWHwDw5U3lK2ihSMwNKVjgKHtasMCqyk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 EAbJz66E660HZBxskhyCd9BIlNk9S8j5JP9OoAEqKfZ4UkLuIRsQi63f+LwrXKgiSKtHa5SxjVRzi48sBEjQu+KScwmcxLRzdYPMuPxhDR9UYjd7m4BryZs/88ClG8QgEAFOLK/wOBaZ98l7fGEcIfn/zZ2ovUkDGRb+2SLE294HcpALO8kfdm0tZK6ONTOjQs/XfC21DFYP5E8f2kCxneyL3m7z4rrwoWEL7WAVb0HNaj/60babeadC6ltXOzmFyf66DVYijVtodp8eVruymRntB/Y3Dz10QZjMJEWDuShYjCNBp2aaBBnJQ9GMqzZg1qyBOYXK8uIwLlTQwVqYDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7769
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FC.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d45ea6c1-cab1-405b-255c-08dee972466d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|23010399003|376014|35042699022|14060799003|18002099003|22082099003|56012099006|10067099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	2R4FGTBpYTTLwA58WfwYXmY/ZCobH3W2oyk8SONqIiCwjhp2r75djeMpCchQTl6yqVOWyf4KhhrVFYWmjI8+BZ/7EV993OOA5hAeHah46foy6ix6hurh/AybXXzj0Kk8jO8fFMfs5xBwniFEgOIKlLc9qN3qWNGtVEFvupuGa24RW3QpfKJtZoHSJd3bNrEq4rQxeRnghYG/uMoo29qSSX5OPT0w1qY6AwlknENv+X65nWfyl8evyK8kPFn2VdDPy6rlVXMaT7C+UiDc4Df3CpphSgCiwTJ0whIj51xQ7SuP+1pSfky08wQVqMqTpaobyJRfV32RRv4ywfgfZRlWEUEGhNxWkt2oNu0gZk/Q/fOTghjh5f5ascIbJ/G42wMmVffLl+zYp7oiMoTqXttzloH4glg8odpAHZtIpQkcQ+I7RL7a2jYF8Np49rrQnrKjygDtW3uwmPlE2cnfzFaz+rWqueOnVXTmtX2TA5jDL+gcEigJiEW5l1UjNVDpAayB8/4tPiOAzuiIi2/eNi+vkxrurKMNT+HOCC/Z72ppuQE0S9LEaZ3/fM8LeRqSnfsgO7fcJghee1VAIygFpsb8KkaQ58rVJwHoQE7KNBId1j6fk7HsVhlzKTr9Mj26u/vFHwjQopm1fu9qq7Yg+PbUlpwIomF3iDdm1qHl2CftHv10vZEDgYyQ3uSYHuCiim1Mk8lh28TkG7eFJKsaNhFN4A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(23010399003)(376014)(35042699022)(14060799003)(18002099003)(22082099003)(56012099006)(10067099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mq0t1UGwTacy0iJueaV9+sJCyq7QmsQNAhzX/Oy4B3EVrvTd4AyuSl8THvxVF8ep3l5jsGygsA9XewZOCuDPQD8hRwS91vPm+ZhAjaFVou3jkcg2ZngwBCwa888dQZPto3QnT7IVLdEu+S4xhdn/xeyDP77/x8UTa+YSI9brO8nuXoyCFqie3Kf61DOTBDu4Lx4G1ubDONXbBKXFkH/NJWK5Ow7L6/AvHcXJQDXjgbann/f4iEDhvV/mtyymNnynJL8otUYa/x4SlMpAA3+q/Djn0FYsKUSnF8ryUIsX5sZpmq/R2sUFIkU4BN579ksy+n18H2aqiCcR9ULTSe3J2AB59CRcSUkyHj5CeMHnCIKgoruoN4aCFaCZECSda9TGw/bWzm7KPgJz77aphIy7P1iH6Yq3fUdcJyIMVW/xzbLfYaVEEcW+fkV1tOt+TDJL
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:57:57.9839
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b69a3b-d9c0-406b-2fd8-08dee9726c02
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FC.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5309

Expose the CoreSight identification registers in the emulated GICv5 IRS
MMIO region. These registers are read-only from the guest's point of
view, so return the architectural identification values and ignore
writes.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irs-v5.c | 78 +++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 57d504181feff..8eadb9a1f1ec2 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -464,6 +464,43 @@ static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu=
 *vcpu, gpa_t addr,
 	}
 }
=20
+static unsigned long vgic_v5_coresight_read(struct kvm_vcpu *vcpu,
+					    gpa_t addr, unsigned int len)
+{
+	const size_t offset =3D addr & (SZ_64K - 1);
+
+	switch (offset) {
+	case GICV5_CORESIGHT_DEVARCH:
+		return GICV5_CORESIGHT_DEVARCH_VAL;
+	case GICV5_CORESIGHT_PIDR4:
+		return GICV5_CORESIGHT_PIDR4_JEP106_CONT;
+	case GICV5_CORESIGHT_PIDR5:
+		return GICV5_CORESIGHT_PIDR5_RES0;
+	case GICV5_CORESIGHT_PIDR6:
+		return GICV5_CORESIGHT_PIDR6_RES0;
+	case GICV5_CORESIGHT_PIDR7:
+		return GICV5_CORESIGHT_PIDR7_RES0;
+	case GICV5_CORESIGHT_PIDR0:
+		return GICV5_CORESIGHT_PIDR0_PART_0;
+	case GICV5_CORESIGHT_PIDR1:
+		return GICV5_CORESIGHT_PIDR1_DES_0_PART_1;
+	case GICV5_CORESIGHT_PIDR2:
+		return GICV5_CORESIGHT_PIDR2_DES_1;
+	case GICV5_CORESIGHT_PIDR3:
+		return GICV5_CORESIGHT_PIDR3_REVAND_CMOD;
+	case GICV5_CORESIGHT_CIDR0:
+		return GICV5_CORESIGHT_CIDR0_VAL;
+	case GICV5_CORESIGHT_CIDR1:
+		return GICV5_CORESIGHT_CIDR1_VAL;
+	case GICV5_CORESIGHT_CIDR2:
+		return GICV5_CORESIGHT_CIDR2_VAL;
+	case GICV5_CORESIGHT_CIDR3:
+		return GICV5_CORESIGHT_CIDR3_VAL;
+	default:
+		return 0;
+	}
+}
+
 static unsigned long vgic_v5_mmio_uaccess_read_irs_status(struct kvm_vcpu =
*vcpu,
 							  gpa_t addr,
 							  unsigned int len)
@@ -780,6 +817,47 @@ static const struct vgic_register_region vgic_v5_irs_r=
egisters[] =3D {
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SWERR_SYNDROMER1,
 				  vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
 				  VGIC_ACCESS_64bit),
+
+	/* CoreSight identification registers */
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_DEVARCH,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR4,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR5,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR6,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR7,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR0,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR1,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR2,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR3,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR0,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR1,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR2,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR3,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
 };
=20
 unsigned int vgic_v5_init_irs_iodev(struct vgic_io_device *dev)
--=20
2.34.1
