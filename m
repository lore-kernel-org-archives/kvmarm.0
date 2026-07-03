Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013024.outbound.protection.outlook.com [40.107.162.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE25290DBB
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.24
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094606; cv=fail; b=eh0HwtzILBtIwCRumg2InnogvwvNghmtCmUbWxSA6K+09xlUUjQuqq0bzUPl0NfZxJd4DxGOA4yguMtLUtDDjsW5Wc3nwkIza4Rr04t/k+HDPc4EtFrKgxtFKGSixZgceSse61JdsJpwpdUoZmyj6HN3mOPWZXCptyDXmb9U7UA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094606; c=relaxed/simple;
	bh=vLVMQpQehwUAfXTMD+DYyFg8CB3SOjcnJ4bgMWg5m1w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DfQj7P5H2YczB7NnA3WEeSVZR9cmyXOIWTW5ZZ2pHkeeie/MRr5MQilGcYiR8dc5qWpVd2UBMoWhMYnc+JI70vjdn3S6f3eYbTD+L7+JmncdVvRJmxojTGQEvcUHAJ1F9Q8s7CAhi1s2cds/u2Sh2c5gzYix/Wl2szsr/y6HnWM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rs+sZ+qL; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rs+sZ+qL; arc=fail smtp.client-ip=40.107.162.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rs+sZ+qL";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rs+sZ+qL"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=l0NcP+RxKhAvbx6XskibjRsO9hI9XiIE0fTb/ROJ666aTgSWWYExBABe6JMtGKyjwhVFNsgHy9FM5fYP6wCR+uOuzSyDg5d1v3OxgMKae+V+G1T8r0tpF1dnP6cevD7DSMFWIz9XwE2L3PysAryvrAk3vNea7Jbqk//dmh4+Zt6AyQedpwasB2h/Aayr4/RKQhxob5rxigZPy4BMj0SA3FICZjKGa9g2w+RlbGZhFWVUXS3laZJGf0NXwPbySd4cj2LN9DciJ/mOaYmXB+JIy+fJD+68EI+vnBjg+q2AD5w2Ra78hedUj5j1KX/fI7AOCjHDiULDnXFbTNa2z4umHQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gi8HJBiMvXAWK7YxURpZ9lxnfXQRir8qbM5Ere9Cm1M=;
 b=bOR6X3hiSGnv1xI4Hb4qLfqQte0Q9XLxCqMAu90whQxATS8OgKfCrqixHY1CHhD0jCv/6duL6p/fd+QhE+ED783nVCxcjW2AAYmSTBeAKPjrCWPkuCFhWeFiXz+dYNyEdHEyUTJv/r4VZHERUoP/paDDrvw4Xh1YDTbirYYzpE+28mYUjLl/+tXY/+0lQyfDsrg71RKTNLtKIDg365YLyRL+7tPPood1O7ckmC6N0cyCl8T/7HYfmoIncrteU13jCKQoopfc4ii278YOhU2n4/nNMXTPGUrLwq7vLt7UICxGt55hpm7m/lkjRnGgSC5qS0T3QbOCkblVSswyxiLo0Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gi8HJBiMvXAWK7YxURpZ9lxnfXQRir8qbM5Ere9Cm1M=;
 b=rs+sZ+qL8V24F4U6bqlP6YOqyGfArFIT4IWbpp/ePXxI3BmJcEchxFPfreC1ucwXCM+jrJdRbj1dTBA2Y9z3B3tOhRWxsrX/bIJNU3j+LBygbbUhesclAxJnH81kH0PzjWek+NRdgaMhv3A5sQiwxmlw18fTyIF16Nk1GbwN+W0=
Received: from AS9PR04CA0156.eurprd04.prod.outlook.com (2603:10a6:20b:48a::28)
 by DB3PR08MB9110.eurprd08.prod.outlook.com (2603:10a6:10:428::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:03:18 +0000
Received: from AMS0EPF000001A6.eurprd05.prod.outlook.com
 (2603:10a6:20b:48a:cafe::21) by AS9PR04CA0156.outlook.office365.com
 (2603:10a6:20b:48a::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 16:03:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A6.mail.protection.outlook.com (10.167.16.233) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:03:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n2zwRAVT7rUu65q0WjN7b6ELx6ahXhejc/g9suWyXNMSFjJp+9tBT5EQ3TAJYiuoI9Kdr+AEXB1bMn9GQKuFZSMtohQkm6QicSgDEepiFp/SecProvy2kyOckounUo3oZO/ze2AFeuxby9NEoFTl9xmE856ch6H1TZei1awruNZyJswlrxxtkGv6TW4iEJ5bqsISptb+lWMl5bYX52wD3mKalmAweU23DXo7/+xPObkOZ5JhRloz3VQ1wbCisKL4NnTTcVOSFde3Ze8H2paFxlnevrOGXcaCJ/9nGx1doUZDPPpoAwoppXWLIRrsylaULANqXa0CqHS2a9zRPu5svA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gi8HJBiMvXAWK7YxURpZ9lxnfXQRir8qbM5Ere9Cm1M=;
 b=DZ9nq4Cz5qo9W+QaIoCPJfQ46kyOafXrCmCl2br3EMRhMPtQ71d56Gv06c4ybTrh56QpEjebTYd92CtM8AkeoCwk0UKXVSS2JKKEx9GGG8fz2G7L/w8aUTr77BRfw0smlrzsOAwPfo1TEsIAjpEmHev7DPGW1PDKM8hO3xZzASyUA7QWt+rMZkaBTxlrqOqlyC8fRgchD/ljcpWrBJX21DsdgXus/cIHjaNUMWN3mmELwyV0mxVpa+2b8AoM9yahO/lh72n1hZUVf8+t3ecp2HlxQzeRpLZas4OTbvplSBkzDZoGcVSAt/kf1H+4AP7azEWygRltnYDGsa5NP5T4eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gi8HJBiMvXAWK7YxURpZ9lxnfXQRir8qbM5Ere9Cm1M=;
 b=rs+sZ+qL8V24F4U6bqlP6YOqyGfArFIT4IWbpp/ePXxI3BmJcEchxFPfreC1ucwXCM+jrJdRbj1dTBA2Y9z3B3tOhRWxsrX/bIJNU3j+LBygbbUhesclAxJnH81kH0PzjWek+NRdgaMhv3A5sQiwxmlw18fTyIF16Nk1GbwN+W0=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by GV4PR08MB11250.eurprd08.prod.outlook.com (2603:10a6:150:2e9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:02:15 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:02:15 +0000
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
Subject: [PATCH v3 23/40] KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS
 enable state
Thread-Topic: [PATCH v3 23/40] KVM: arm64: gic-v5: Set IRICHPPIDIS based on
 IRS enable state
Thread-Index: AQHdCwVQPWmLJFHgdUS0om/TT2vVKg==
Date: Fri, 3 Jul 2026 16:02:14 +0000
Message-ID: <20260703154811.3355680-24-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|GV4PR08MB11250:EE_|AMS0EPF000001A6:EE_|DB3PR08MB9110:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c258dff-ebf7-4632-edb4-08ded91c98ab
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 1UWbeal3RJjpAT2fB4FEJ6ywuU2FtHXrQ2tIEuc7wQwGGj8WRRRVXNcoUUTclC8qgiS7+W1SZhzkcw0vjAsYrdXFtTq4otZfF+eXpFsU3laTtNn/LA9OcF//JwCIiJoIfrN8nCTkPpWOxE4sQQgYXv+xgppM0tT3AV4BHiBJ9HSFUJOnMWdN+G7gw2onuFUTayNByqrw0UZpbjeT61C3oCjUEeEJM4d9srH6oyfsjFtQ1ntaVV9uiq20KnR4Ae/MZPv8W5sUR0Hpb3cv50Vp1JGraFmhKFZ5vKqSPIcNXkyuwAELYp9RhGI7Ppkas/8PmrJw6AV3fs1o4eObLuLQnUTywcURqCqkqI9fvW1rf+f7061jW51ZlFoeQilbNO9UjCZKqRqhzVOXCj34zXxrZTF2TpFyZUBY9WMxb/8G0yMP5y+RPeQsQHJiz3CFgaHIfAryNyjptll42ic1Dvz9cmSky4regPeWba++g++upjBj9iBo9IUX0TgxCTmqMNGrrDHxdyeqLoc34pnk0FsG3IatA7KdJbC7OqYGs3/EaZYPdEmW+JcFtC1Pg5iDj4U3fRGEDLKzehHf5cVIW6C5lzfwi2cJFZJQH8M4cb+Rb9OSrbgWfDKYZ2f767x86YewbbfdIWMtbrWGZ8qN18E/QoI4k63RfVlbJhFh2MMUtsHQLgHqiuKNTLRCcX8e/sACXeAz/DpHdWIuA0ebvC6cnsrP31Gzou801W94YQqbtAs=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 e5OEBImhhPS5YLSFbH8VnxkXX7wglyLsC7tg6v8IbdHpP86LJnOGny6xoCbqLAHRPvJ/wGZvUsGRDiPgeoxC1Bp1652pfYZZrhApTUjfMJmBWPyCX7QWETTSmd6Bo9q502A2ldhl09zJwn2GsfCZaHwlM57ZJfnAb1Mb/SAxCNjgzz4lTVBX1lwT+ply4fbsl9i6K3qOOTbHqeJlbMsGhXF+Qe6JRwKC97KWeFLQJaOyMlPiqOPn1cR8WzHR9e5HNWY0jG3cHSDW3r2dVQ1JJbOE8s/9aMZQFVbhQUyN7obxDFfsgFvmTBtdhf1NeF5QrYjuFM+tcQ+quVUMvjt4YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4PR08MB11250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A6.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	363e8506-4f09-4c7a-ccbc-08ded91c7351
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|23010399003|14060799003|35042699022|376014|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	2VI56uL98O8v7TBfulusVqIMkSkWf+DyyIPZSN6/ofAvm6CdoSG6aPcFw9qO1yotx6tyMltvNBfgPtFZFvQhdVIAfjLiOX1ZaK6QEmqDi8Tl5SVOlUvoF5cg8UBE55MU1Bf/DSeBB6wR6xM8VlYwhl/wPxF0SR54iwdP0l95AO8xSO1N2gbEGp85KO3W/Cv/+gwjB4EnXb6pr+Tb1kPqoEblVP2chzI+ReT1dYCFstTDPLzCpaGuHJANr3nUTqkBKWnoefJ4PZRNfbslG6wOryy9gSn66Hn8IaAZFWLbKKUP7l4mqgA2526J8I2+cr1Lg5O98RCMvByb5pJseihSO4t/iPPFCRqVOsBhIeJCJu2FurrD+MEGlnnedwLzFIJQjgalFvYemTVbyFgRXWAizp2Y5GEoVrYYTtnTNyeZ3+L5LKKDIXvGbf413LfKH4qbD0HCljnPGWVWgDnX03qvRFvJ2qVqjxDYTyPtbV8YcwIOK1eY78BSccjOx6IC0+iHzlKSAkX1S4ldq/SNIT/6iWS462NcVJ1iNFX3PaSfPE9anZtSP1T1sP4ygHVF/qXlOYpD4UW8Vze0zTnCu57NjjDEWze9mowvo9lrzwCe4uAAXnSrnlFvBWiS2nPPyNxSVthHuWWEiX8heoLvx5jxjz2YhEuwkgqMpaoJCctUb6qhYjVkFIR5sqMr+WXjsMQA/KiTcmiZU1W8yW7Vxonh0w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(23010399003)(14060799003)(35042699022)(376014)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CQZlmswnVUM4avsiplXTVbKZBzvervkKo2S8V+vsfh6bI/pIQTiUBCX4R9f5IQ7IoOxQqQb1ebcjhFN9bCve5+bhIvvxS3AOdBru3XbarlYZRgGrSj8PHWpFs+Qhr93kPPTeu9skFGTNjpRbEuOYaDZRmUcBSOZm/mIcsr8KCCMho5guNDKlQ+L6uIDJThd8gviTxXF4CAzVY6tw9p11APRqNDmxuC7zO7jl1y7lsNmu2o8dFPTmaK2nUJUlv+HezillrEWqy9zC9DGqCMhYDb26idSvyon1qR2NbOl5AIpENONKC3VFLq/+wcCN0pzRZ+Vio4MLMftvCRk8nvY0oKDm6iJ7PTmlupPzyRgcz3vd0LB/v1Jp9RSV8f0u4UxeK3s+xKUn3jKmhbE+8Xdpjv9XeJqXKif5+3Dxwr70fVEGmdf7LivA0WMUn7afy4vk
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:03:17.5909
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c258dff-ebf7-4632-edb4-08ded91c98ab
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A6.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB9110

The GICv5 ICH_CONTEXTR_EL2 has the IRICHPPIDIS field, which allows the
hypervisor to enable/disable the HPPI selection for SPIs and
LPIs. This can be used to emulate the guest enabling/disabling the
IRS. Therefore, make the state of this controlled by the IRS enable
state. Thus, SPIs and LPIs can't be delivered to the guest, until it
enables the emulated IRS, which matches the behaviour of the real
hardware.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 2df61426cc714..ffb0500a4c9a7 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1058,6 +1058,7 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
=20
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
+	bool irichppidis =3D !vcpu->kvm->arch.vgic.enabled;
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
 	u16 vm =3D vgic_v5_vm_id(vcpu->kvm);
 	u16 vpe =3D vgic_v5_vpe_id(vcpu);
@@ -1074,6 +1075,7 @@ void vgic_v5_load(struct kvm_vcpu *vcpu)
 	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
=20
 	cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_V, true) |
+				FIELD_PREP(ICH_CONTEXTR_EL2_IRICHPPIDIS, irichppidis) |
 				FIELD_PREP(ICH_CONTEXTR_EL2_VPE, vpe) |
 				FIELD_PREP(ICH_CONTEXTR_EL2_VM, vm);
=20
--=20
2.34.1
