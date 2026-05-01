Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011015.outbound.protection.outlook.com [52.101.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB7A3FE665
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 16:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.15
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777653814; cv=fail; b=T89/BktsmnUqXsYOT3va1n0Shp5NKPAfmtPygkGu9xJoNofdQJsbIsaB4Bfh6igYAWVhwMy8NlWRJBTpv0AmyejQSpN44FKcFnHrOTJ5GB2Hub0HBnbiUwZMUa6hqVP80GvUEA6oBiB/RfraPk7mqa35Cy4c7a6ejl97rNRu228=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777653814; c=relaxed/simple;
	bh=of9qNFRYVsqvtmDxih3AnX/rw3cTRfuZjgD+vrczSi8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pV654f3LVl4Fn++KbCX0GB2erufdRM/msp8VblYLtXeXoKNRJjqr60q1kXIaVyNsoHVXU/WVDfFAE3BDs0rSx0Sf6SyGo4jSWlc8oLWrxMsb8XOCJzgtwUCy0mFE7+lvvHDJ44oiQjw4l1+8L2AHwd2zx7W/XMi1+Hgb5RtkBW8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KYsXB+XW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KYsXB+XW; arc=fail smtp.client-ip=52.101.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KYsXB+XW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KYsXB+XW"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=feyZH4SWN4if98fHzwUwlsiYkCPjnkCpb4F4NGxRO/4rsuNxpsftFUc8GazNQuSbqnGbDM/AnR5dkQV2tucjtWWPTppPJeWo4PHA2MRv2RlGKsYBSyv3iX2QOltjCV6gxnzbwyfIDas1KD6F3vf/ebXIr/PZhie6U756+QsT6KL0KrvH9kP8SLl2pUHCnyWtdiD/d0q1pmkCnGCGcT4+C8AUKzX7/xySAU28pXiPzbL3RGJTvcWzg6kFAFK8hW+Y7UD/uE9gv9o7TMs950MQMyMKjR2omd7htoH1GJyesGwo5I7O0tShPz/viw5Z39tuu1Ce1/Ux2micuIU/kuLHXg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=of9qNFRYVsqvtmDxih3AnX/rw3cTRfuZjgD+vrczSi8=;
 b=EZ1T68M3b6ovdlTQG6e+q425t/BogFRw6Z0b5sEY8DzNT1lHlbIoqfLHebyAuxJobCnVzMyiFeYgMDkdhZYkjLcUlZtQipvGJ1OboHyUyfsDF/U1JIFR75C3lWxIUJ4swZO4MwWqRGn3dYv6vBN5NPl3YIuL9a60vxW/2D/br1HBn9p3H9gEJR4LUvVqGXUdTKQeNbzVYOWpbqeWWoMyZjgw+3PvKUufuvQonXLWcFhSaTu2iKgHdZv+o7M+PHfn5TXOoOqebQduynSbevVIwvdssrfA3qr1JMImM3tFCcn8JLGtO4iyYaEYFDYblL+mhzYF8lQOuI/BPA5uKxtixw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=of9qNFRYVsqvtmDxih3AnX/rw3cTRfuZjgD+vrczSi8=;
 b=KYsXB+XWQ+QxA5j99dfFHrgTi3v0R97thXoWYM8e4wRK+lltk1Z9OnHwxNtfYBX7Ezi+CCnJ67OzrZi+6TuNiF9mziJc2ZKdv60HoAqHRS6440H6C7IgX42WUbA9wTfwM6nD+Zp8DoGH4+BNw+1yc+EpIJLxMFdnjL0Ypb8JdNA=
Received: from CWLP123CA0265.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:1d5::13)
 by AM9PR08MB6001.eurprd08.prod.outlook.com (2603:10a6:20b:2d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.23; Fri, 1 May
 2026 16:43:21 +0000
Received: from AM4PEPF00027A65.eurprd04.prod.outlook.com
 (2603:10a6:400:1d5:cafe::30) by CWLP123CA0265.outlook.office365.com
 (2603:10a6:400:1d5::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.23 via Frontend Transport; Fri,
 1 May 2026 16:43:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A65.mail.protection.outlook.com (10.167.16.86) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Fri, 1 May 2026 16:43:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MEZAgXnXa3xoZzSkNcvpqxWBtcvhrJK/WfPZoeHqSuQeFpsaEf5GcRX7ig+yv2Nw0ucUMprJLCUSyrB9a8mA3kRuZwHx6vCVMZFw0oKqylemNHNcZq7YgSk9r6awMLNdE/YadtMjfoeEkVIkIMLZXEGQ+8RoFcc8X7OX54UQxunKOhQ6ahprRPt8+fVFmJ219w5KH8AZWa7ZSpGFLUcATgMcjq5LaUSunHsvzvHXqSPHVmPbTzpSKhPzEWkMg5JCYkFP3FZPfcVaKgLrI2oISQE+HtKQZ/j5jBcPJs7daLWu1bkgBqVOFVohMtLxVICxkTCiSl7g0422sMHiPLueMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=of9qNFRYVsqvtmDxih3AnX/rw3cTRfuZjgD+vrczSi8=;
 b=xQyk8ALGBRhvsYc4pohWUdAcvbqYtvrmfIjD419n3Fj+4zk0FaHJL5/wzLNLvrzu/bo/nxAF/z/z1/3GdTQBTv/EC0F6tIXCZksOkLahfcyk2xtBVwoB3OoPpngOB3SjpfRD4xKC3KO1gKDTbxbbPXYG6symUkut/tKw493u9xoVy3hfMJLrZWLY+TE0qLdWs0xofMw6PzoruicIpk1sNn09t5cB2G4co5t/DUCiXfk5XgpIzyQfGWmC8dtT9U9nBe2Y6Pd6N0k4meAyu9Z/ELuKSLd1WhcrmxVY3auIveQ/xqIhb/uUvvxoP3qDSluKcsLWdalhS/Dv27pQJtt3jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=of9qNFRYVsqvtmDxih3AnX/rw3cTRfuZjgD+vrczSi8=;
 b=KYsXB+XWQ+QxA5j99dfFHrgTi3v0R97thXoWYM8e4wRK+lltk1Z9OnHwxNtfYBX7Ezi+CCnJ67OzrZi+6TuNiF9mziJc2ZKdv60HoAqHRS6440H6C7IgX42WUbA9wTfwM6nD+Zp8DoGH4+BNw+1yc+EpIJLxMFdnjL0Ypb8JdNA=
Received: from AM6PR08MB3399.eurprd08.prod.outlook.com (2603:10a6:20b:47::18)
 by VI1PR08MB9958.eurprd08.prod.outlook.com (2603:10a6:800:1c0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Fri, 1 May
 2026 16:42:17 +0000
Received: from AM6PR08MB3399.eurprd08.prod.outlook.com
 ([fe80::59cd:4b6:fceb:3de7]) by AM6PR08MB3399.eurprd08.prod.outlook.com
 ([fe80::59cd:4b6:fceb:3de7%5]) with mapi id 15.20.9870.016; Fri, 1 May 2026
 16:42:17 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Vladimir Murzin <Vladimir.Murzin@arm.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, nd <nd@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>
Subject: Re: [PATCH 07/43] KVM: arm64: gic-v5: Create & manage VM and VPE
 tables
Thread-Topic: [PATCH 07/43] KVM: arm64: gic-v5: Create & manage VM and VPE
 tables
Thread-Index: AQHc1mAUg8cc+Wo/p0+C9FJ2cphGj7X0kP8AgATVMAA=
Date: Fri, 1 May 2026 16:42:17 +0000
Message-ID: <0bfea1fb09df1108750ec9f164e4fbd6fd13eeb7.camel@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
	 <20260427160547.3129448-8-sascha.bischoff@arm.com>
	 <9de41a97-0701-447e-bb28-63796eaa8f60@arm.com>
In-Reply-To: <9de41a97-0701-447e-bb28-63796eaa8f60@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AM6PR08MB3399:EE_|VI1PR08MB9958:EE_|AM4PEPF00027A65:EE_|AM9PR08MB6001:EE_
X-MS-Office365-Filtering-Correlation-Id: ec8c3599-209e-449d-ed47-08dea7a0c13b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|18002099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 UYq8I27WPB3ABJd5v7zjHHAu53ivyZpLlLWrqWlrYDE8OcEeIKfWAXg31wmduXUqSd09K4Z12dxOx9SzjB5N5PM+hQX6YLC/ho0pHKAjwy36oIIrCD45HJe1f9Ey8maQIkOoYfrHcfndPneuNvY6vh915bRDo2sHAWTH8vNLWthYghQExND4sSuKVboswolXuPzJ0CjgQ+alHh6cQFKWQRTbruROSogPcGBnzdyNJwlDVHXTshAMCBQcxSD2JpfKrJ8RDH7Ko/0sBsoFBSVk4l0Zpx1ZEuNFUl3XXKB5wkzOCqWfyok7GIMMnGb34OPWpX+YHqiQeLjnIDC77NISMyXSM4/sGCSWAO2nsQvDn+js9ULRiIj6sT2QeD1tVArxpeGHNfEO9OUAWEETvZY2gu8+KfVjIzLZgkm88hv8CHka1E0nE/SCGZkyCZVUXKBFORpsqYEh5T28BUAgLirGbP3UG+lheVQr7FauOclfu05kTIvTJ3CKy3E85B3AQ1c5a/Q3mOaB2N4o/4pjnkhaIJlFt8j9Ww6y+xiLV1iV8uNUqQBNPLokfcCoCCO5BTLRlQYCcFR7jqjCdAceQdF0yx4yMR0l+JbSuUnj95TfDJ/XH6tlYF6HFVObzrUA7+wK+kP1voV3Xau8dTgZqPTM1+3EieHI4BFH6QTPmy9+gMNuabSfOUPdX0VdFByh3YLzbwl7exiJEpSoxOh1iLWQCXwBmQ4zSR4EeRMlWCDqY25NNV3fLAdJ+t5gyHSEqGSk
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3399.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <14BC5CA01957A3488CB8F8836AE67932@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Hf35/DcDp0u+6k06IfFIkplycnGa/qn+cDAk1MxqGAbyx74vHc9c8DT8W6/ZC+Gefn/OqNAi34hg9Fz0V0mVOMVYhLlstP1y+27GTP00nWyqh8jlB1KzFYDIP0koaMG9I3NzWhWUsWu7TEfPPh6UJa8O6aEYR8CyjPOf0SoXSA0fnTOpCxRukoWVhKpoTr7HXJmMfSYD4/6NMUlv7S3dvsvUVebawTWC5WPAvuVc+vApbIFsnoYLz8LvqEFAub39Y3o5cPPfh3TUzWPV4Afy/KygaGerjvP465XjA8zKPmErPeEtPdv2hTLFr87RNlqsplvjAs7dVIwrA+0DCdURhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB9958
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A65.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	795f7ed5-f470-426a-09a8-08dea7a09b41
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|1800799024|35042699022|14060799003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	XqZ0Cj7+iBoyFmZbnuLIDS+wUKas9H8uDfR9QP1KC3AgxkyrrAZdjFfCRdvdjBCCHXIO3mWVndYdiYDTYtpBbFE0PpKOf09h5rrMY5WQS7ci8jkPvDMzf2wJesMvjko6k3/Yt7WksYWfnbnUFe8xs9HH1wOEtS3hvW89g+s06yjFNsS6znSdJl2vvby/5DifkcCLDbkQqj+LLmeL2+H14oCdkfSA/HWv0EOa3n32uaQruN+YVz/FMrmjXXg0cnX9zt3qjF/pKa54T9R6H9XQzRcmoBwcnWzrd4qir1pclLYbsel0SfXEuX7XBKmA1+HbzAWMItSulQmx6JnvtHm+1AAM06jPu8hgAGdT7H/Qd2W/M7wvvZl9A5rKDsIXH9+BawiwJ3yyZVbZvTNrRZCMJxykdzjqP5t0Nya/ek1/3PjtwZyeDytA5EmnlmNX9kDsB4fUbhV48rCOAafgFsKlPTRkhUhPbyhk7CYVkkOTOvwdwYcaueyxoJeAuniDkFYhasUJkBqjqw+xnD7MvB3e9A3ITFpnERvQ32p1fnNUqRyvueUlywn8MYg/p8+IUorpynZtmaHpTQnABAk1lwsixUSpvMvF3P0PUUCKl0Yv5cOx/wcAiIgIsRjUnJSfyqRbH5w46rUoD+8H2kg2fBqcIZvsotJB1ZXdhBAm8Vadkx6Pa0DITawGsYwmzCObNLHBJawDUJXNcVUJVpRN7cyAN1u6srDXK0grbvS/SYhNQsE=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(1800799024)(35042699022)(14060799003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4cBLNIbzXflpy8j8zHWINSNCt4eEt628w1JRW8PhEE5tpXfDGVNj4U1g1IJ3vHt32Vh7x+tSoxXoLWADYdvEbYS56vCjmWXPemIZcxBuIPd+32LDW9hU2rkrAcGtAgVaYUj9wIi+jgAeCxlHMXPD7QXs9Mmw8123krXzeMf+rZI/2AhQMkY7CKOUEbXzFS9XTeWOUiuHoYXUirNBgiPA960st7DrlPAW1/sf023SMnvG4rzsSPAXToZ32/TiVzAW7gvzXOP9wNEc4a6l6CbCghwSdtNOq81OnG+Sch3LOQuVkUf5tT3Hmy1LC83CjLc/p2i7uLJtE/bPOfj3IFMGek2QImQxCCXqXXMufojrzkR7jJW73KCUVEeOBpkMzfXiHCwRbnNbdwQ6obe+qKnT7Bi4y3FSuq2o6XUSZPoVdIGP73u6JvPN9ASrnNyIcUq3
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 16:43:21.0901
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec8c3599-209e-449d-ed47-08dea7a0c13b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A65.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6001

T24gVHVlLCAyMDI2LTA0LTI4IGF0IDE1OjU0ICswMTAwLCBWbGFkaW1pciBNdXJ6aW4gd3JvdGU6
DQo+IEhpIFNhc2NoYSwNCj4gDQo+IE9uIDQvMjcvMjYgMTc6MDgsIFNhc2NoYSBCaXNjaG9mZiB3
cm90ZToNCj4gPiArDQo+ID4gKwlpZiAodmlydF90b19waHlzKGwyX3RhYmxlKSAmIH5HSUNWNV9W
TVRFTDFFX0wyX0FERFIpIHsNCj4gPiArCQlrZnJlZShsMl90YWJsZSk7DQo+ID4gKwkJcmV0dXJu
IC1FSU5WQUw7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJdm10X2luZm8tPmwyLmwycHRyc1tsMV9p
bmRleF0gPSBsMl90YWJsZTsNCj4gPiArDQo+ID4gKwkvKiBBbGlnbm1lbnQgaXNzdWUhICovDQo+
ID4gKwlpZiAodmlydF90b19waHlzKGwyX3RhYmxlKSAmIH5HSUNWNV9WTVRFTDFFX0wyX0FERFIp
IHsNCj4gPiArCQlrZnJlZShsMl90YWJsZSk7DQo+ID4gKwkJcmV0dXJuIC1FRkFVTFQ7DQo+ID4g
Kwl9DQo+ID4gKw0KPiA+ICsJdG1wID0gdmlydF90b19waHlzKGwyX3RhYmxlKSAmIEdJQ1Y1X1ZN
VEVMMUVfTDJfQUREUjsNCj4gPiArCVdSSVRFX09OQ0Uodm10X2luZm8tPmwyLnZtdF9iYXNlW2wx
X2luZGV4XSwNCj4gPiBjcHVfdG9fbGU2NCh0bXApKTsNCj4gDQo+IEl0IHNlZW1zIHRoZSBzYW1l
IGwyX3RhYmxlIGFsaWdubWVudCBjYWxjdWxhdGVkIChhbmQgY2hlY2tlZCkNCj4gbXVsdGlwbGUg
dGltZXMuLi4NCg0KSGkgVmxhZGltaXIsDQoNClllYWgsIHlvdSBhcmUgY29ycmVjdC4gSSd2ZSBk
cm9wcGVkIHRoYXQuIEdpdmVuIHRoZSBjb21tZW50cyBvbiB0aGlzDQpjaGFuZ2UgaW4gZ2VuZXJh
bCwgSSdtIGdvaW5nIHRocm91Z2ggYW5kIGRyb3BwaW5nIG11Y2ggb2YgdGhlIHBhcmFub2lhLg0K
V2Ugc2hvdWxkIHRydXN0IHRoZSBhbGxvY2F0b3IgdG8gZ2l2ZSB1cyBzYW5lIGFsaWdubWVudHMs
IHNvIHRoZXJlJ3Mgbm8NCnBvaW50IGluIGNoZWNraW5nLCBtYXNraW5nLCB0aGVuIHdyaXRpbmcu
IFNhbWUgZ29lcyBmb3IgdGhlIENNTyBzaWRlIG9mDQp0aGlzIC0gd2lsbCBnbyBhbmQgcmUtd29y
ayB0aGF0IHRvIGJlIG1vcmUgc2FuZS4NCg0KVGhhbmtzLA0KU2FzY2hhDQoNCj4gDQo+IENoZWVy
cw0KPiBWbGFkaW1pcg0KDQo=
