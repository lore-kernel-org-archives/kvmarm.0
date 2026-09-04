Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011031.outbound.protection.outlook.com [40.107.130.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A56846D57E
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.31
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522037; cv=fail; b=BUEZ3kxC1L2QuFcpljt86H1P1/XL8wCU6Lf0ZXQqPdx5tZJw/qCbCmb0PMVOwp+tkxqzVW/IB6QlRvOHf/6chQsb9Gx1K5Bmg/rCMlY0XK3K+QDPVp9ZUb4YUmX5fU0l7GpzrhJRzyHoU4aJ5PIrz7KYHphT5h+6h7LSvXle3N4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522037; c=relaxed/simple;
	bh=E0TvmTAojdja79UfLl7mMUn50ZRbE+tMYbImBAqf8YI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RmOqi5ijg+4Po+aBMitfiHflV6AJl/HuuAywbzvwcanO1Kem48qaJb776X1cLKhK7iQ3LCDPIv2XRkxJGxkkNoHvlLlKshLOD6ahDlIxfi0EFpUQ07vjdLtVCSnxhokfr7qZuaVrzVYRwA4Q0tVcDib6FqnFM3OqOdSUVLHI1NA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kHpUIBUR; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kHpUIBUR; arc=fail smtp.client-ip=40.107.130.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kHpUIBUR";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kHpUIBUR"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ofNt92VmEyidkvyfcWXiSs1HrzNAz5isHzGN9/HdsNBLREwelI4yWPn4M6UbUjq6gkeq29PS5VUcV3nujLEEzadkWwrIXlgH0yjBmfG79K7yBj4g8q2eI5BIhwC3Ltx3pOd5Pi/4/CreLQSBoav3jgUuSKi7XEv9xThyl4WthKe1T3qNQMSCWl4+mSEOgtMOeZxx61jP4wBVatexCPlFk9+5+YR67OPzjq0XrdmyaBs2rXDnZEKTq6zFAWnrVwuP5ytI7Smt89JIwSxNTWXBdLzEX/rEs6U0NgGCDjOu0vPCHhF7hP1l2XPcsF8RdiiOhVcElOSJFtazaRykooXWLg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tKpg7DZky2TxTNyBryFeBRsQHAD/c3MyW24u4aETMeA=;
 b=sZ2Tcq5JyMfvkdQaofsSXdIrbY/PZsvupFgw4r8gdD2ksKiyzjUSTC5/OfnJVo3T27s5ErcpmEViHOq9wtnxCnBAUlc2ZHoGvyTLebcYV1nEpQkkCDt97e53VZbJ3hV+wmV0xH/1PUDbyF1ytddzAoqpxtIqYB8EKlIReGebLY27+qRIFCrLm26lPIteD77nuMeYqfVN3ZvWv3U6SY2B8iUbUDCDOKcl4510mWAvva8P0BBjGTTfHAZMUrPIeruzO+l7t/yN412yibR+93GlsrwBLG+JbER5gnkSHkecWVDmKYUoeyeB7jUiRlYSy65KTCc2scwJVnNUkSuAcqg6bQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKpg7DZky2TxTNyBryFeBRsQHAD/c3MyW24u4aETMeA=;
 b=kHpUIBURdFhlkTjIaHgi2plY+O94zAkYwaC8BVeeS9DTDNWWcgUE5ac4vVB0D0XOXQqFWBWSmljlegoPkukbzVfwHBCvRi4ZpAk1cS3bCOQQbZ5TI2AiDk0it5b8D942cwlLaSxJPbSIPQ6i8cDOgTR7mCSy6zS7Aa4v1iaLMOw=
Received: from AS4P192CA0052.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:658::6)
 by PAWPR08MB10307.eurprd08.prod.outlook.com (2603:10a6:102:366::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:40:27 +0000
Received: from AMS0EPF00000566.eurprd02.prod.outlook.com
 (2603:10a6:20b:658:cafe::30) by AS4P192CA0052.outlook.office365.com
 (2603:10a6:20b:658::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:40:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000566.mail.protection.outlook.com (10.167.242.116) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:40:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sZNRs+SJkF6xkjmjRmaKUWjDZUHR70upKhTvh4FNZ/NyZKUVagYeADTn7Dq/qhshL1hh4jir6q3Ii/SAhKp38JCSxiUKmAeor1KcGLRBjsnkxgwxGH82Tbq8JXYZBTwLfArONcDH3aBy011I5IH9Au0S/J8ronligxukNWMpoYhUi0vRap9JqvqXUp9Fg9JtyECMceRjjX3i+/UCo+EMJGXLEAg/L9dT+81uTjfUeebNHnX0t949yEMWOlWyX64L6irZ8PrvbwrgQQeGvx5Qmsl0ujm96JIGDKE2bL7Z6AvOCLtMz3LQnIUjADTdtNNB20YC0VOSkZ/6OEskAzM1aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tKpg7DZky2TxTNyBryFeBRsQHAD/c3MyW24u4aETMeA=;
 b=nl9sw/MYie6b1YTqf0vVIfIOu1plzcI1qwcWzaOgkvxu/UTGoNe7Zi88xouPkPuxdzgmzlaOwJzHVQZdkT32bm0YUA4tjXMeHZDj7r5J9y0MMSb4VuUxLanB5HsF3LmMaZy7KL8UZO2VuahRWbcvafJPiMBXlJ2SHCoXJsuC5irL07fM/8OfwK8i1mT0YaHScym+2XmYykNktTqFGGYfVZ8qe321fVcIvj93LYIUwIPIHEdlHZh4js7IfIyDYRjxniRhUk4d2kfj6y67GQqAulqprFyMIghav+dLkiutosPwwBHvKoNhyMSJNtZf7Ew84Mf5Y1CRoJVu2dh7vdW43Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKpg7DZky2TxTNyBryFeBRsQHAD/c3MyW24u4aETMeA=;
 b=kHpUIBURdFhlkTjIaHgi2plY+O94zAkYwaC8BVeeS9DTDNWWcgUE5ac4vVB0D0XOXQqFWBWSmljlegoPkukbzVfwHBCvRi4ZpAk1cS3bCOQQbZ5TI2AiDk0it5b8D942cwlLaSxJPbSIPQ6i8cDOgTR7mCSy6zS7Aa4v1iaLMOw=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by GVXPR08MB10864.eurprd08.prod.outlook.com (2603:10a6:150:154::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:39:52 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:39:52 +0000
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
Subject: [PATCH v6 11/49] KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops
Thread-Topic: [PATCH v6 11/49] KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO
 Ops
Thread-Index: AQHdPGIZh0L7bAtRekOaqtu5liRXFw==
Date: Fri, 4 Sep 2026 11:39:52 +0000
Message-ID: <20260904113404.4051341-12-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|GVXPR08MB10864:EE_|AMS0EPF00000566:EE_|PAWPR08MB10307:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e88ccd3-9526-41c8-e62f-08df0a795062
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|6133799003|10067099003|3023799007|11063799006|22082099003|56012099006|38070700021|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 ryySCpTYHv3Kp+009vR9WuXv5myqWA6FrwfW395p001SSvCvGJO2f06HC3Fdw3V1Oz9PdZ4LYRPbAEGPzVi5CNdVclaEc5ZPaPptrOe6vRcyTs77bhUUCjdARjitPaDqsSXbejmIfjlihqDSaC9l7RhyQwaCi7uKDe0FMfy7t+k/D87XyU+/IT9Wqk3IxQUhH+/+ZpwPDYHHjIO8vNxsHAEMuhqXMRGh4vBWdnlbeqmVx5lxsxUZjY/z/A3HtAdhIa7DlmVf2ULdBZFpz6fYQoCUGSos8dH+TYPcHDxPI89W3KSoTpBOUmqTEX0PFJKUjcB/0DBka2Z1Fy3wQGwvtQZwcWT0HD7CqJ+G36Vf7eKyD/EN0fTRN5gTK2OgUJxTdMu6jeaEdnDfHpKus/vyBJFfyg6FjTXHTPcIvV+16d8dBFk+3EXdWIFOmtTZA6Vv8NQeOMx9JRL9f+P2U2ej/cLVMvzKB/QvfRYP+D6ZaWI+jUOBJ3VtxdRJcuQn4fh22Sv2zpI/PnBadoVQFjH79TvblwxHG1uYxjsoRx9MfQY5Rhu4w32i8GihPeZ3gbot0XR76ZUjfga1u+XHbzdJgqrCuziW+GiMs2/Yz6I0qUoXv/V69nuYQlPJYX4RNIH3XTmy3aXONgGFRWPTCILOHiB51NqtOrHz2topDS6efByzVaw/r72THdzIBs4W4yjziHohdhhZxkOzT6zuAC0+vaYPFhhjx9u8kOlIphY20wM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(3023799007)(11063799006)(22082099003)(56012099006)(38070700021)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 gxa26xGoSr81ANu0BNbVtfnpXVBWKrlwCN1QaeqoSdkFKG5TmF2NHpwZuHhBOc7uOJ5JsZNM9ZrFe/Blk1V8ObyeZ2oVMJWiGLNOJr0YQ/PX7O3e9rU9xkFXoukze+OHLAVgXXhiH81uWkRPek6clUS+mN3CD1TGVKfhiFgz4zUF6X7aE6WehUk2//mw7nz6z+UTwLEyT/42jeuJ/cH1rIXgO8kb8RZsoi8ghA56UQ1yukTm7I6mMV1zHkqvr5kt9dWYQHvqeed86SKD2mXjtzuTR/ngVoB6mjZntKm3erLSaSDbIi0ZKgP3Ep1RZUGtv/ewga0bNORZr9yVeUt2/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10864
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000566.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	084ead42-cfa9-4d47-8904-08df0a793c13
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|23010399003|14060799003|36860700016|82310400026|1800799024|6133799003|11063799006|10067099003|3023799007|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	8C9cL1iaufiJN+I7KeCLZ6uF9x55dCdQ4S1PR4D9N8Qh4DjgDBXLsOyyEqMI5PrZXVZgsUUJ8fU2b1x+PWgtFZsB1zPatU319xEBxvePYguxHNqMNdyD4upryMpJcy5UNIDo5AK9hwjYwqjsYmJ8pIu8BWWTDuCyUQrJWYudL040n1V7sUDkUANKCysJXb85/a06MEXfrWeoHJP7XeOhzf8SDw7BsFccda0rrh8R+vz8NiIjzAqNpOkEvsfgNAKwVYf31I1qE3AtDLf4aT5D0FlXUGtJI7RX61ud1ljibf5cigYZWIQTs9ArZt/8gN61tUuZN0YGnX3bcuFRSbHuAF9qxkABlkc6ooloWLIC5apEgiI0KgErUgTqVTPhiVOeMeX1hGmqaEcp8sUkGkd5Tl9xke4FOnMtGswuGDL7kYnBk1XbcvkH/sVcHue3IEf2vWPo0kz2AnS/G0ePXUtXwZMp3inI75XLMQa/VAqnzYM4ZET7YfttvgAP/Wx3ligFkEkTOBj9c0wrfJCOz3VCoSvIjKUbNi4/MCPjA8a0b46kzv7TFVh0Zt+dSl1+UDghx9ajB9EHfWJNJ40Fy8KGCfbqy+YWJA6iYJL0OAMKXEnjpYt5uNVQR7JV8aQPZRaVLbmY7dZlJycUAx3l5OhRUIGGkS3AKeO/VPSODiTZ63g=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(23010399003)(14060799003)(36860700016)(82310400026)(1800799024)(6133799003)(11063799006)(10067099003)(3023799007)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lw1C66jfGMzduumBpjOUTCukPtW7PapsTz7nP0o2wozca3fZjFnN10hIALRBlHn0F7ydpqX9o42d7nBz5xnmAkdLVRQZdjOboTS6u9/foS1td3RXo/HoCdN35eSVTwW6z8vFk7dHohMlbm2atGcYxgCyDtVU13gXJxIWShz7tcoyGcT5MoOivNMXAnry3O/Z0F7STQgRbphaHlui72utln0hIfKEcwgQLhxHZs/JumkIYvsShym2ODvxT1WrxNMsp3T8RWDG6ChnLDUUDibmsApRHMhxEZxcp1yUCyX36MV8JyTY6kvdH70NDZ7mQq1j6xWgcXVeoDoRidPoN3PzK3/r6MqFUkSO4M27rTcjnQGtx/P0zoTP42Lkv4elDj4dRNakFi9N5dkmy1U43fpJTyRdMQfNvN29FkdGDPIbGH7yhKp8afWRbIL48VosYQCI
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:40:26.4843
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e88ccd3-9526-41c8-e62f-08df0a795062
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000566.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10307

GICv5 has rules about which fields of a VMTE (or L1 VMT) may be
directly written by the host once the table is valid. This ensures
that no stale state is cached by the hardware, and provides a clear
interface for making VMs, ISTs, etc. valid.

The hypervisor is responsible for populating the VMTE for a VM.
However, it is not permitted to write the Valid bit, as the VM table
is already valid. Instead, the VM is made valid via an IRS MMIO
operation. The same applies to the ISTs: they must be made valid via
the host IRS.

This commit adds support for:

* Making level 1 VMTs valid, allowing for dynamic level 2 array
  allocation
* Making VMTEs, and hence VMs, valid or invalid
* Making SPI ISTs valid, and LPI ISTs valid or invalid, for a specific
  VM

As part of this commit, the following vcpu_affinity-based commands are
plumbed in:

        VMT_L2_MAP - Make a second level VM table valid
        VMTE_MAKE_VALID - Make a single VMTE, and hence VM, valid
        VMTE_MAKE_INVALID - Make a single VMTE, and hence VM, invalid
        SPI_VIST_MAKE_VALID - Make the SPI IST valid
        LPI_VIST_MAKE_VALID - Make the LPI IST valid
        LPI_VIST_MAKE_INVALID - Make the LPI IST invalid

The lack of SPI_VIST_MAKE_INVALID is intentional.

An IRS command timeout does not indicate whether the command was
consumed.  If VIST assignment times out, retain both the VMTE and IST
allocation and mark the VM dead. This prevents KVM from freeing memory
which may still be accessible to hardware.

When successfully probing for a GICv5, allocate the VMT and make it
valid through the IRS MMIO interface. Treat failures while allocating
or assigning the VMT as hard GICv5 probe failures. At that point the
IRS VM table state is a prerequisite for vGICv5 operation, and falling
back to the legacy path would leave the host without a valid GICv5 VM
table setup.

Conversely, if vGICv5 registration succeeds but registration of the
optional legacy vGICv3 device fails, retain the working vGICv5 device
rather than failing the entire probe.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5-tables.c |  75 ++++++++---
 arch/arm64/kvm/vgic/vgic-v5-tables.h |   1 +
 arch/arm64/kvm/vgic/vgic-v5.c        | 192 ++++++++++++++++++++++++++-
 3 files changed, 242 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index f088006f39674..c028c4fb95e01 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -73,6 +73,21 @@ static DEFINE_XARRAY(vm_info);
 #define GICV5_VMTEL2_LPI_SECTION	2
 #define GICV5_VMTEL2_SPI_SECTION	3
=20
+static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
+				    unsigned int id_bits,
+				    unsigned int istsz);
+static int vgic_v5_alloc_l1_ist(struct kvm *kvm, unsigned int id_bits,
+				unsigned int istsz, unsigned int l2_split);
+static int vgic_v5_alloc_l2_ists(struct kvm *kvm, unsigned int id_bits,
+				 unsigned int istsz, unsigned int l2_split);
+static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm,
+					   unsigned int id_bits,
+					   unsigned int istsz,
+					   unsigned int l2_split);
+static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi);
+static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi);
+static int vgic_v5_spi_ist_free(struct kvm *kvm);
+
 /*
  * Our IRS might be coherent or non-coherent. If coherent, we can just emi=
t a
  * DSB to ensure that we're in sync. However, when non-coherent, we need t=
o
@@ -561,25 +576,6 @@ int vgic_v5_vmte_init(struct kvm *kvm)
 	return ret;
 }
=20
-/*
- * The following set of forward declarations makes the code layout a *litt=
le*
- * clearer as it lets us keep the IST-related code together.
- */
-static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
-				    unsigned int id_bits,
-				    unsigned int istsz);
-static int vgic_v5_alloc_l1_ist(struct kvm *kvm, unsigned int id_bits,
-				unsigned int istsz, unsigned int l2_split);
-static int vgic_v5_alloc_l2_ists(struct kvm *kvm, unsigned int id_bits,
-				 unsigned int istsz, unsigned int l2_split);
-static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm,
-					   unsigned int id_bits,
-					   unsigned int istsz,
-					   unsigned int l2_split);
-static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi);
-static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi);
-static int vgic_v5_spi_ist_free(struct kvm *kvm);
-
 /*
  * Release the VMT Entry, freeing up any allocated data structures before
  * zeroing the VMTE.
@@ -723,6 +719,18 @@ int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
 	return 0;
 }
=20
+phys_addr_t vgic_v5_get_vmt_base(void)
+{
+	phys_addr_t vmt_base;
+
+	if (!vmt_info->two_level)
+		vmt_base =3D virt_to_phys(vmt_info->linear.vmt_base);
+	else
+		vmt_base =3D virt_to_phys(vmt_info->l2.vmt_base);
+
+	return vmt_base;
+}
+
 /*
  * Assign an already allocated IST to the VM by populating the fields in t=
he
  * corresponding VMTE. We re-use this code for both an SPI IST and LPI IST=
, even
@@ -785,8 +793,30 @@ static int vgic_v5_vmte_assign_ist(struct kvm *kvm, ph=
ys_addr_t ist_base,
 	/* Finally, mark the entry as valid */
 	cmd =3D spi_ist ? SPI_VIST_MAKE_VALID : LPI_VIST_MAKE_VALID;
 	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);
+	if (ret) {
+		/*
+		 * A timeout does not tell us whether the IRS consumed the
+		 * command, so we're in some indeterminate and potentially
+		 * transient state.  It may still make the VIST valid and access
+		 * the backing memory, so leave both the VMTE and allocation
+		 * intact. Killing the VM ensures that teardown is the only path
+		 * that can reclaim them, after it has successfully made the
+		 * complete VMTE invalid.
+		 */
+		if (ret =3D=3D -ETIMEDOUT) {
+			kvm_vm_dead(kvm);
+			return ret;
+		}
=20
-	return ret;
+		scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+			WRITE_ONCE(vmte->val[section], 0ULL);
+			vgic_v5_clean_inval(vmte, sizeof(*vmte));
+		}
+
+		return ret;
+	}
+
+	return 0;
 }
=20
 /*
@@ -1137,7 +1167,8 @@ int vgic_v5_spi_ist_alloc(struct kvm *kvm, unsigned i=
nt id_bits)
 	ret =3D vgic_v5_vmte_assign_ist(kvm, base_addr, false, id_bits, 0, istsz,
 				      true);
 	if (ret) {
-		vgic_v5_free_allocated_spi_ist(kvm);
+		if (ret !=3D -ETIMEDOUT)
+			vgic_v5_free_allocated_spi_ist(kvm);
 		return ret;
 	}
=20
@@ -1207,7 +1238,7 @@ int vgic_v5_lpi_ist_alloc(struct kvm *kvm, unsigned i=
nt id_bits)
 	phys_addr =3D virt_to_phys(vmi->h_lpi_ist);
 	ret =3D vgic_v5_vmte_assign_ist(kvm, phys_addr, two_level, id_bits, l2sz,
 				      istsz, false);
-	if (ret)
+	if (ret && ret !=3D -ETIMEDOUT)
 		vgic_v5_free_allocated_lpi_ist(vmi, id_bits, istsz, l2sz);
=20
 	return ret;
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index a711a247cc6be..38b6f5269a2aa 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -106,6 +106,7 @@ extern raw_spinlock_t vgic_v5_irs_lock;
=20
 int vgic_v5_vmt_allocate(unsigned int max_vpes);
 int vgic_v5_vmt_free(void);
+phys_addr_t vgic_v5_get_vmt_base(void);
=20
 int vgic_v5_allocate_vm_id(struct kvm *kvm);
 void vgic_v5_release_vm_id(struct kvm *kvm);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index c65355483f64b..3d8f17301567a 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -16,6 +16,9 @@
 #define ppi_caps	kvm_vgic_global_state.vgic_v5_ppi_caps
 #define irs_caps	kvm_vgic_global_state.vgic_v5_irs_caps
=20
+static int vgic_v5_irs_assign_vmt(bool two_level, u8 vm_id_bits, phys_addr=
_t vmt_base);
+static int vgic_v5_irs_clear_vmt(void);
+
 /*
  * Not all PPIs are guaranteed to be implemented for GICv5. Deterermine wh=
ich
  * ones are, and generate a mask.
@@ -43,6 +46,21 @@ static u32 irs_readl_relaxed(const u32 reg_offset)
 	return readl_relaxed(irs_caps.irs_base + reg_offset);
 }
=20
+static void irs_writel_relaxed(const u32 val, const u32 reg_offset)
+{
+	writel_relaxed(val, irs_caps.irs_base + reg_offset);
+}
+
+static u64 irs_readq_relaxed(const u32 reg_offset)
+{
+	return readq_relaxed(irs_caps.irs_base + reg_offset);
+}
+
+static void irs_writeq_relaxed(const u64 val, const u32 reg_offset)
+{
+	writeq_relaxed(val, irs_caps.irs_base + reg_offset);
+}
+
 static void vgic_v5_irs_cache_id_regs(const struct gic_kvm_info *info)
 {
 	irs_caps.irs_base =3D info->gicv5_irs.base;
@@ -62,6 +80,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	int ret;
=20
 	kvm_vgic_global_state.type =3D VGIC_V5;
+	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
=20
 	kvm_vgic_global_state.vcpu_base =3D 0;
 	kvm_vgic_global_state.vctrl_base =3D NULL;
@@ -82,13 +101,52 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	vgic_v5_irs_cache_id_regs(info);
 	vgic_v5_get_implemented_ppis();
=20
+	/*
+	 * Even if the HW supports more per-VM vCPUs, artificially cap as we
+	 * can't use them all.
+	 */
 	kvm_vgic_global_state.max_gic_vcpus =3D min(vgic_v5_irs_max_vpes(&irs_cap=
s),
 						  VGIC_V5_MAX_CPUS);
=20
+	/*
+	 * GICv5 requires a set of tables to be allocated in order to manage
+	 * VMs. We allocate them in advance here, which alas means that we
+	 * already have to make a decisions regarding the maximum number of VMs
+	 * we want to run. For now, we match the maximum number offered by the
+	 * hardware, but this might not be a wise choice in the long term.
+	 */
+	ret =3D vgic_v5_vmt_allocate(kvm_vgic_global_state.max_gic_vcpus);
+	if (ret) {
+		kvm_err("Failed to allocate the GICv5 VM tables; no GICv5 support\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * We've now allocated the VM table, but the host's IRS doesn't know
+	 * about it yet. Provide the base address of the VMT to the IRS, as well
+	 * as the number of ID bits that it covers and the structure used
+	 * (linear/two-level).
+	 */
+	ret =3D vgic_v5_irs_assign_vmt(vgic_v5_irs_two_level_vmt_support(&irs_cap=
s),
+				     ilog2(vgic_v5_irs_max_vms(&irs_caps)),
+				     vgic_v5_get_vmt_base());
+	if (ret) {
+		kvm_err("Failed to assign the GICv5 VM tables to the IRS; no GICv5 suppo=
rt\n");
+		if (!vgic_v5_irs_clear_vmt())
+			vgic_v5_vmt_free();
+		return -ENODEV;
+	}
+
 	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
 	if (ret) {
 		kvm_err("Cannot register GICv5 KVM device.\n");
-		goto skip_v5;
+		/*
+		 * Don't free the VMT itself if the hardware still has a valid
+		 * pointer to it.
+		 */
+		if (!vgic_v5_irs_clear_vmt())
+			vgic_v5_vmt_free();
+		return -ENODEV;
 	}
=20
 	v5_registered =3D true;
@@ -113,12 +171,13 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V3);
 	if (ret) {
 		kvm_err("Cannot register GICv3-legacy KVM device.\n");
-		return ret;
+		/* vGICv5 should still work */
+		return v5_registered ? 0 : ret;
 	}
=20
 	/* We potentially limit the max VCPUs further than we need to here */
 	kvm_vgic_global_state.max_gic_vcpus =3D min(VGIC_V3_MAX_CPUS,
-						  VGIC_V5_MAX_CPUS);
+						  kvm_vgic_global_state.max_gic_vcpus);
=20
 	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
 	kvm_info("GCIE legacy system register CPU interface\n");
@@ -128,20 +187,145 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+/*
+ * Wait for completion of a change in any of IRS_VMT_BASER, IRS_VMAP_L2_VM=
TR,
+ * IRS_VMAP_VMR, IRS_VMAP_VPER, IRS_VMAP_VISTR, IRS_VMAP_L2_VISTR.
+ */
+static int vgic_v5_irs_wait_for_vm_op(void)
+{
+	return gicv5_wait_for_op_atomic(irs_caps.irs_base,
+					GICV5_IRS_VMT_STATUSR,
+					GICV5_IRS_VMT_STATUSR_IDLE,
+					NULL);
+}
+
+static int vgic_v5_irs_write_vm_mmio_reg(u64 val, u32 offset)
+{
+	int ret;
+
+	lockdep_assert_held(&vgic_v5_irs_lock);
+
+	/* Make sure that we are idle to begin with */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	irs_writeq_relaxed(val, offset);
+
+	return vgic_v5_irs_wait_for_vm_op();
+}
+
+static int vgic_v5_irs_assign_vmt(bool two_level, u8 vm_id_bits,
+				  phys_addr_t vmt_base)
+{
+	u64 vmt_baser;
+	u32 vmt_cfgr;
+	int ret;
+
+	guard(raw_spinlock_irqsave)(&vgic_v5_irs_lock);
+
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	vmt_baser =3D irs_readq_relaxed(GICV5_IRS_VMT_BASER);
+	if (!!FIELD_GET(GICV5_IRS_VMT_BASER_VALID, vmt_baser))
+		return -EBUSY;
+
+	vmt_cfgr =3D FIELD_PREP(GICV5_IRS_VMT_CFGR_VM_ID_BITS, vm_id_bits);
+	if (two_level)
+		vmt_cfgr |=3D FIELD_PREP(GICV5_IRS_VMT_CFGR_STRUCTURE,
+				       GICV5_IRS_VMT_CFGR_STRUCTURE_TWO_LEVEL);
+
+	irs_writel_relaxed(vmt_cfgr, GICV5_IRS_VMT_CFGR);
+
+	/* The base address is intentionally only masked and not shifted */
+	vmt_baser =3D FIELD_PREP(GICV5_IRS_VMT_BASER_VALID, true) |
+		    (vmt_base & GICV5_IRS_VMT_BASER_ADDR);
+	irs_writeq_relaxed(vmt_baser, GICV5_IRS_VMT_BASER);
+
+	return vgic_v5_irs_wait_for_vm_op();
+}
+
+static int vgic_v5_irs_clear_vmt(void)
+{
+	guard(raw_spinlock_irqsave)(&vgic_v5_irs_lock);
+
+	return vgic_v5_irs_write_vm_mmio_reg(0, GICV5_IRS_VMT_BASER);
+}
+
+static int vgic_v5_irs_vmap_l2_vmt(u16 vm_id)
+{
+	u64 val =3D FIELD_PREP(GICV5_IRS_VMAP_L2_VMTR_VM_ID, vm_id) |
+		GICV5_IRS_VMAP_L2_VMTR_M;
+
+	return vgic_v5_irs_write_vm_mmio_reg(val, GICV5_IRS_VMAP_L2_VMTR);
+}
+
+static int __vgic_v5_irs_vmap_vm(u16 vm_id, bool unmap)
+{
+	u64 val =3D FIELD_PREP(GICV5_IRS_VMAP_VMR_VM_ID, vm_id) |
+		FIELD_PREP(GICV5_IRS_VMAP_VMR_U, unmap) |
+		GICV5_IRS_VMAP_VMR_M;
+
+	return vgic_v5_irs_write_vm_mmio_reg(val, GICV5_IRS_VMAP_VMR);
+}
+
+static int vgic_v5_irs_set_vm_valid(u16 vm_id)
+{
+	return __vgic_v5_irs_vmap_vm(vm_id, false);
+}
+
+static int vgic_v5_irs_set_vm_invalid(u16 vm_id)
+{
+	return __vgic_v5_irs_vmap_vm(vm_id, true);
+}
+
+static int __vgic_v5_irs_update_vist_validity(u16 vm_id, bool spi_ist, boo=
l unmap)
+{
+	u8 type =3D spi_ist ? 0b011 : 0b010;
+	u64 val =3D FIELD_PREP(GICV5_IRS_VMAP_VISTR_TYPE, type) |
+		FIELD_PREP(GICV5_IRS_VMAP_VISTR_VM_ID, vm_id) |
+		FIELD_PREP(GICV5_IRS_VMAP_VISTR_U, unmap) |
+		GICV5_IRS_VMAP_VISTR_M;
+
+	return vgic_v5_irs_write_vm_mmio_reg(val, GICV5_IRS_VMAP_VISTR);
+}
+
+static int vgic_v5_irs_set_vist_valid(u16 vm_id, bool spi_ist)
+{
+	return __vgic_v5_irs_update_vist_validity(vm_id, spi_ist, false);
+}
+
+/*
+ * LPI ISTs can be invalidated explicitly. SPI ISTs are invalidated by mak=
ing
+ * the VMTE invalid during teardown.
+ */
+static int vgic_v5_irs_set_vist_invalid(u16 vm_id, bool spi_ist)
+{
+	return __vgic_v5_irs_update_vist_validity(vm_id, spi_ist, true);
+}
+
 static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
 {
+	struct vgic_v5_vm *vm =3D data->domain->host_data;
 	enum gicv5_vcpu_cmd *cmd =3D vcpu_info;
=20
 	guard(raw_spinlock_irqsave)(&vgic_v5_irs_lock);
=20
 	switch (*cmd) {
 	case VMT_L2_MAP:
+		return vgic_v5_irs_vmap_l2_vmt(vm->vm_id);
 	case VMTE_MAKE_VALID:
+		return vgic_v5_irs_set_vm_valid(vm->vm_id);
 	case VMTE_MAKE_INVALID:
+		return vgic_v5_irs_set_vm_invalid(vm->vm_id);
 	case SPI_VIST_MAKE_VALID:
+		return vgic_v5_irs_set_vist_valid(vm->vm_id, true);
 	case LPI_VIST_MAKE_VALID:
+		return vgic_v5_irs_set_vist_valid(vm->vm_id, false);
 	case LPI_VIST_MAKE_INVALID:
-		/* Not yet implemented */
+		return vgic_v5_irs_set_vist_invalid(vm->vm_id, false);
 	default:
 		return -EINVAL;
 	}
--=20
2.34.1
