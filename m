Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010045.outbound.protection.outlook.com [52.101.84.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AAA392C46
	for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 15:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.45
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786461127; cv=fail; b=Jt4wW+TluNgcL5HmjVwb6dMtBDf2SHsqTrKuq2PLOOVusYozkctw6pfMNqsBCMTvZejA+lg2KCgCR6XQWm+DsdB+8rqeUpY0Ip7Lro+uXOZjcRnsTP8L3g/3rlKJOL+v4WSiUODRw6sOOM0Ka0H9Nbd+gCmwfmB+EAPV2SH5NoQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786461127; c=relaxed/simple;
	bh=q+0y3mrD5zDdkpuQxbIwssRNlfJvUQ3+QhlfPnxVCFE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tyI9o+lZ0xOb8QB+G9LTvDoRo5EfQV2c8SlRcD8s6MR97ZPeMGa6alB+jSY41/WVFrZN3slfuUJYoMlnbay44w5BDPKvrSR0fywuhanQw1cfz3QtCzXgNvf8ZRJtaYZl21hibotaRTZKbsPRiuRroC6seSAkSYWDTGeeR5toQJ8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TDJbxMJg; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TDJbxMJg; arc=fail smtp.client-ip=52.101.84.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TDJbxMJg";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TDJbxMJg"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sWWk6pSlD8byBmR2/xXkPH8cc9TGXvKqJ4rKu9Jk+XCcRgeNJI1xeqzOC+k9IHFW/oRkvR121nsi4pjzENGveIGD0q+O0a6dj4bUxsCg/DbBAHcJfwzvDglJZ6scOnNPuL5Kr9SHvBpAIBe7cVaLqBA2P0kQvu7Ugw5juD2q/aNhk2q542KAXCU+1ObaEOYdD87XhmkN663hybZzPVdqLf3lIVijQE6aSurGFbFtF+TNDlGzI9XT3iL6FMJL5Xa5prpQVEm1aF4ZqLveGDFl+pVwIAdzZRHdn8lcFOX3/tPrZbGJelF6/ny6O9/jNyyzIDHtYmGVke0esyJOPOmr2Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q+0y3mrD5zDdkpuQxbIwssRNlfJvUQ3+QhlfPnxVCFE=;
 b=Ji7jlxl+JV5SeUyNj/+Hc4Xw8J1TPLcmusZkl5MYQecoAVq7e5z0eA7SsW0wu05QaCwpv6dD4EGKYpKlTjVTiQiUNiLrfoFNkjk7hgWKneYJqlryaSjGGJwxn4ci5ButtuUfNcREPTCXmItVOzyLIp8Wxih9gDhlhpePjUBB/awQJUPEpWeNLDObj/0oWKqvEfcH392f/4Ne7kaaVT7QWeI2xQYcgC9Qh7AvBU8UQ86iOMYrXQA9QYfhRsBtg4B31FMhlWmO8bsgjj+2a1UguxFjqGbMSQpAq59xZj3pDEEmhyYaY67cres5FqHkHX0TFB+3HoogjOyDAIef+OjjKQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+0y3mrD5zDdkpuQxbIwssRNlfJvUQ3+QhlfPnxVCFE=;
 b=TDJbxMJgplYHRdnhuZY9Raky6GcNKW05ROyJYnfaJFEgXZ2OtBk0VCaRkJX0gt2SnkKA5cIagmV08x/dZqLAclPNCU7z2JmDvAmDPPwa9zNZZ/cIcvFNDzBA6ryVBxr3G7eimibEAFCH+SI1KAkUIkFCUx6B3NTp+DsaiKuvmx4=
Received: from AS4P189CA0014.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5d7::17)
 by AS8PR08MB7861.eurprd08.prod.outlook.com (2603:10a6:20b:52c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 15:11:52 +0000
Received: from AM4PEPF00027A6C.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d7:cafe::3e) by AS4P189CA0014.outlook.office365.com
 (2603:10a6:20b:5d7::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.11 via Frontend Transport; Tue,
 11 Aug 2026 15:11:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A6C.mail.protection.outlook.com (10.167.16.90) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Tue, 11 Aug 2026 15:11:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cR8AWF7/EtVq0iKH8rAyxDNao8KSVedx1sN/eW48J7vN3fUVE/FYv3jmXTZLLPtVGel0WM+njKkU1WH8SWmfBZi7NH4VUCuE1RJ28HsKrcMzdMs3m/1bQggB3ZBKH09oIFuwuC6BxSEgzi6DIDWGeaX2Gr9VRiHTsk5NHIj1YaLrFV/5mUA+aZy/mc6ZznhjFf8HSL4DnDK7GE2F/29G5C80X8E9ERM1ulG1mNaYsgFOeIrwd64zGQtmVSPsvdl54LVKz6zIKSosigbfnAOV4ZRvactYvpU7B3rgW/1KgKniC+8XMq1iZlmmZfXxHJH7ehbZ5tL1qFog+KqffNl9WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q+0y3mrD5zDdkpuQxbIwssRNlfJvUQ3+QhlfPnxVCFE=;
 b=CFcm/oD+u1ZeprtqRfdpXlP34F2w8dkfKSt25aDhcWq0jzQnsil84Va7ikmBadNfaddxznYkaLfMmh8l78dc9UD/xqIB9fYnc+hyvfVJxLnkBQxBOVwMLLMcP1xO2Y2RQkVWk5IsBUoBc7cxe1aU41kFHikROyJ/KeNNTVY8emkjUmJDIzRiQGQuiYys188aEPPlSu8x+Z50uIChYwoZzsXF4AjE10bnwuDjRxza2S00OQiRCKqCTANeA4No63zqCjMt9TjgplT+uNhtrWr1+is4jbRphH/WyiamKckfY1jQp7MiL3Oi0fS+CUO1PqtEoeKOKL6cAbA1b9LnKgFIRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+0y3mrD5zDdkpuQxbIwssRNlfJvUQ3+QhlfPnxVCFE=;
 b=TDJbxMJgplYHRdnhuZY9Raky6GcNKW05ROyJYnfaJFEgXZ2OtBk0VCaRkJX0gt2SnkKA5cIagmV08x/dZqLAclPNCU7z2JmDvAmDPPwa9zNZZ/cIcvFNDzBA6ryVBxr3G7eimibEAFCH+SI1KAkUIkFCUx6B3NTp+DsaiKuvmx4=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV1PR08MB8214.eurprd08.prod.outlook.com (2603:10a6:150:5d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 15:11:18 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%6]) with mapi id 15.21.0315.008; Tue, 11 Aug 2026
 15:11:18 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>
Subject: [PATCH v2 3/4] KVM: arm64: vgic: Reject out-of-range GICv5 PPI IDs
Thread-Topic: [PATCH v2 3/4] KVM: arm64: vgic: Reject out-of-range GICv5 PPI
 IDs
Thread-Index: AQHdKaOoMQb5WWMOvE2620AciVvx8Q==
Date: Tue, 11 Aug 2026 15:11:18 +0000
Message-ID: <20260811150941.941295-4-sascha.bischoff@arm.com>
References: <20260811150941.941295-1-sascha.bischoff@arm.com>
In-Reply-To: <20260811150941.941295-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|GV1PR08MB8214:EE_|AM4PEPF00027A6C:EE_|AS8PR08MB7861:EE_
X-MS-Office365-Filtering-Correlation-Id: 44d2be40-1eac-4ebd-327b-08def7badfdf
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|38070700021|10067099003|56012099006|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 YaO0JH1swwZlp3aLeUue0q/1mAzMQmUUNOutbkwc5EiWmdiXyWRtXhU6zf7Efy+ok9wWOMrnAvryLxy+AhTWWpeQIWD1wM5SYlkJMCwZzfNgGAjJqkrWNAhjoPPZ1FnagueUiUpwSK9P/vnpFM8WRfny0kFBJEcKdvcgVyNWjS4+i/rBZFFHhou8LU7YtEcGjA6aHLVmsv6HqZV5nYMcspwB3AuJ9gp6lXE8/joKKozWEz47rXrGgMNWbu+eJZ+21sq8xeOZuWZSBE1/pkWjI2mQGpkKgxorXeAmaXr8ODhlzsqFJkLKHtfrdCse08xVwH/ruAe+vZkRTPmWeG0Ne/nmHptIfunLa3LdJ22EH8bmM4Hafsl2GP9w00f4roISmsK1OZlFFC0jc9+WVNo4b3pKpMvDiRoDaSZcNXxaNuA5wnKqXieN+UNxuiQWDrJg2SdsS0ilqK2ebLMvUeGv67K577OsIwv8c/qe2xe3wqDQ6fr43OB4HwDNGi2nSzBS/qGdAy0ipnMb7dVbAKexVa/hule7m9ReKwf4VeyF2jibdTIFMlm56HS4wKG7brQEohYm/GLh6VPXyWbjPegbEfXAg9rNIyku40uoSWqnjflwGB7Tza+BlVphdHuB0wyvRVZNhGCW+BbMzMnOFTYb4B70G55vLL+9ixRP/8xTfIA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(38070700021)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 BNqzBVlZDraarC3ZKW6v39hSek3fs3b5xJ8oPbyHbvLGhx9/Rh3IW55kwTkaKoIS4qLVivkJ5AZrg/BivrQaIBK+l57j3+RQIasPjISCx+JoUaW1S30otBnQSiDD1NqNE1fDu38nDFGzykEdXabG9nnLQqfBcEzkTBpXxsy9GeWjWXfhNPaTgBv6nSj/yc4fmwIE83G0JMFalGBYaASSeShUdZ9zQDng4u7WpMLq4Mwq29rOMPhu+Q7OH3ygL8hzIa9U3ZFij6dMoxfzr6KH6+s20CQUHNnyR35dUGZjV9XqHBmiYEjCI39J89FSWzfIKFc9+Qzl/bRHucKOyWMSOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8214
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A6C.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	efb91331-4ad1-4aed-4b1c-08def7bacb5e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|82310400026|14060799003|36860700016|35042699022|13003099007|22082099003|18002099003|3023799007|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	++ypL1sQGPpGgeaVI5s3bbNBDGKYP7k70qLDimhU7YVSrRTrPCnSfVjabKeze4sf2gP1lXqKFt5LZdtD36xdut47SUHF3E6lTmKf3Ge6CmmmA95w8M1qU0Fgp2NoA16im2GxLpId1OBecEqiLJyvjgEp0WzlPB4rrJe/NRK0JFj52h/G0vQeX57hhf5DnUzJ5r2tY1Fm/7G/qVkQxHpdt4IdKr7Ko3sXMkQeEA2v/KKn0FanmARmNhvcFyltZD/4iZvxZZKt7NSZiQhnHOK/i1+68eYKkp4Tr0N6QPpQ77rHkIUUuMg8yv8kTxeda44br/PFtL0aPaGqF+TDstgp7M03HSkXEhLyEpzdgYzK+PWDQG5DJZIaiuzqIrBWyc9mCBfpaGHCSiiiOvZMpat09BdkAd6Vx6EVOJAclHMaMu/NDg0GcCYakY7UVEOskRfD8AXoIqszPXRJk4BJbWr8wOcfazsToMaQ3InOEaRtcUOjd569wQjjDO5SfoVIr5UZJgt+BYWUJVwoPl6FHVFQAVShyOFuUv/6Bws3qHC/6b+/05UNUjPT+w1ajywEPjgMMIfVVLzMFyO2IWIclR+wLGhPw5tP/JbWL3+eDchztcAJ2GGuRqYjraXkmhz2ofQAULE2B/s3hkbg3gf0QCPGDg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(82310400026)(14060799003)(36860700016)(35042699022)(13003099007)(22082099003)(18002099003)(3023799007)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RdpnRkngWAPv74znxCqnN/N8GAb+SglfjPVy+NK6DnlJyvbIytuFPccOM/ISDmvobDe5kZPTAaEdZKDAMhMEbF75gaGyI/VFc6SsvdRzS4VMXAQj1VaceGFceWI8zrTzeAEupbR8PjWcuEK2xg20U8dFo6GYDTkq1JY1aCtBItphVXF1LaQaF599MwbJt2B4l4tfXkgM2L79c68yguNBMzCZZ2F9W0sqrfXCYcU5616yk8T5RvsKbqyaucnBZ77CllcozfBLtXXbbRXYJybHC8kJFOJJvGNjb2AfmSocXW7UGgOGSQG/7lYoLrrnj5Eifx+2nnnIRtamvLKtLlJH9QkBUWcmN2Xe5AkAltrwBxcaLWrkITAWSfgrz55nVvmVRioBzErG0N2TTcGEtYAZrmksXhMhaeGy/xT28Xtwbs1OHUFkzs45R/4EpzlBaHeo
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 15:11:52.4272
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44d2be40-1eac-4ebd-327b-08def7badfdf
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A6C.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7861

R0lDdjUgc3VwcG9ydHMgdXAgdG8gMTI4IFBQSXMsIGJ1dCBLVk0gY3VycmVudGx5IGltcGxlbWVu
dHMgb25seSB0aGUNCmZpcnN0IDY0LCB3aGljaCBjb250YWluIHRoZSBhcmNoaXRlY3RlZCBQUElz
IGl0IHN1cHBvcnRzLg0KDQpBbiBlbmNvZGVkIFBQSSB3aXRoIGFuIElEIG91dHNpZGUgdGhhdCBy
YW5nZSBwYXNzZXMgaXJxX2lzX3BwaSgpLA0Kd2hpY2ggb25seSBjaGVja3MgdGhlIGVuY29kZWQg
aW50ZXJydXB0IHR5cGUuIHZnaWNfZ2V0X3ZjcHVfaXJxKCkNCnRoZXJlZm9yZSBsb29rcyBpdCB1
cCBpbiBwcml2YXRlX2lycXNbXSwgd2hlcmUgYXJyYXlfaW5kZXhfbm9zcGVjKCkNCmNsYW1wcyB0
aGUgb3V0LW9mLXJhbmdlIGluZGV4IHRvIHplcm8gYW5kIGFsaWFzZXMgUFBJIDAuDQoNCkluY2x1
ZGUgdGhlIHN1cHBvcnRlZCBQUEkgcmFuZ2UgaW4gaXJxX2lzX3BwaSgpIHNvIHRoYXQgS1ZNIGlu
dGVyZmFjZXMNCnJlamVjdCB1bnN1cHBvcnRlZCBQUElzLiBBbHNvIHJlamVjdCBhbiBvdXQtb2Yt
cmFuZ2UgUFBJIGluIHRoZSBsb29rdXANCmFzIGEgc2FmZWd1YXJkIGFnYWluc3QgY2FsbGVycyBi
eXBhc3NpbmcgdGhlIHByZWRpY2F0ZS4NCg0KRml4ZXM6IDRkNTkxMjUyYmFjYiAoIktWTTogYXJt
NjQ6IGdpYy12NTogSW1wbGVtZW50IFBQSSBpbnRlcnJ1cHQgaW5qZWN0aW9uIikNCkZpeGVzOiBl
YjhiY2UwOGVjYjEgKCJLVk06IGFybTY0OiBnaWM6IEludHJvZHVjZSBpbnRlcnJ1cHQgdHlwZSBo
ZWxwZXJzIikNCkxpbms6IGh0dHBzOi8vc2FzaGlrby5kZXYvIy9wYXRjaHNldC8yMDI2MDcyNDEw
NDgxOS4xMjk2ODAzLTEtc2FzY2hhLmJpc2Nob2ZmQGFybS5jb20/cGFydD0yNw0KU2lnbmVkLW9m
Zi1ieTogU2FzY2hhIEJpc2Nob2ZmIDxzYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCi0tLQ0KIGFy
Y2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5jIHwgMiArKw0KIGluY2x1ZGUva3ZtL2FybV92Z2ljLmgg
ICAgIHwgMiArKw0KIDIgZmlsZXMgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1n
aXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuYyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdp
Yy5jDQppbmRleCAzNTJkNTJiZDYzMTVjLi5iMjUzMDNkOTkxOWZkIDEwMDY0NA0KLS0tIGEvYXJj
aC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCisrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5j
DQpAQCAtMTE4LDYgKzExOCw4IEBAIHN0cnVjdCB2Z2ljX2lycSAqdmdpY19nZXRfdmNwdV9pcnEo
c3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1MzIgaW50aWQpDQogCQlzd2l0Y2ggKHR5cGUpIHsNCiAJ
CWNhc2UgS1ZNX0RFVl9UWVBFX0FSTV9WR0lDX1Y1Og0KIAkJCWludGlkID0gdmdpY192NV9nZXRf
aHdpcnFfaWQoaW50aWQpOw0KKwkJCWlmIChpbnRpZCA+PSBWR0lDX1Y1X05SX1BSSVZBVEVfSVJR
UykNCisJCQkJcmV0dXJuIE5VTEw7DQogCQkJaW50aWQgPSBhcnJheV9pbmRleF9ub3NwZWMoaW50
aWQsIFZHSUNfVjVfTlJfUFJJVkFURV9JUlFTKTsNCiAJCQlicmVhazsNCiAJCWRlZmF1bHQ6DQpk
aWZmIC0tZ2l0IGEvaW5jbHVkZS9rdm0vYXJtX3ZnaWMuaCBiL2luY2x1ZGUva3ZtL2FybV92Z2lj
LmgNCmluZGV4IGNlZmRkYzljNjIxZGUuLjFhNTQ5Y2NlZWNiZWMgMTAwNjQ0DQotLS0gYS9pbmNs
dWRlL2t2bS9hcm1fdmdpYy5oDQorKysgYi9pbmNsdWRlL2t2bS9hcm1fdmdpYy5oDQpAQCAtNjUs
NiArNjUsOCBAQA0KIAkJc3dpdGNoICh0KSB7CQkJCQkJXA0KIAkJY2FzZSBLVk1fREVWX1RZUEVf
QVJNX1ZHSUNfVjU6CQkJCVwNCiAJCQlfX3JldCA9IGlzX3Y1X3R5cGUoR0lDVjVfSFdJUlFfVFlQ
RV9QUEksIChpKSk7CVwNCisJCQlfX3JldCAmPSBGSUVMRF9HRVQoR0lDVjVfSFdJUlFfSUQsIChp
KSkgPAlcDQorCQkJCSBWR0lDX1Y1X05SX1BSSVZBVEVfSVJRUzsJCVwNCiAJCQlicmVhazsJCQkJ
CQlcDQogCQlkZWZhdWx0OgkJCQkJCVwNCiAJCQlfX3JldCAgPSAoaSkgPj0gVkdJQ19OUl9TR0lT
OwkJCVwNCi0tIA0KMi4zNC4xDQo=
