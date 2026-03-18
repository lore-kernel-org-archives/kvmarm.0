Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013067.outbound.protection.outlook.com [40.107.159.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF1A315D49
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 17:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.67
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773855087; cv=fail; b=Xek7aKwFIGhMWeDnS/d9airhC/lWDcsUn6SQCOXQwIBAXWdgbYz1E+HjLl4pQ49dBL8fYonmIFM0YT7v5AGawsCi4aOcrfNtYN5vR1SrTaBg8T4AoYhtcOdciHTt6aVxNlbpYLuRCMOYakxokFAcussM6ahPfvSO5wd/f3DffxE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773855087; c=relaxed/simple;
	bh=wy35sV/neLBKXRnQ6KFUsrLFfSYFi7/h2N7cM5WF7aM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gqzxG9ssjw2OHXkLCPzp5uOZGbGJDbdFc9UYU26Rq17984s99Dbdj8CXwsKPCdHDBIVX8BglV/GqQ7Kjc4Z3zzlbiupDqGkq4IVuroc4TsrSr/lVQ/g4G0juYibGFk4KQTSREQ6UxILO5locgAva619zvqTryDgywTlc5GRkuW4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FqxrEqVE; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FqxrEqVE; arc=fail smtp.client-ip=40.107.159.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FqxrEqVE";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FqxrEqVE"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=L2KEDb6gDFjsQdf2gU9xIV9PNos3Tjk96zxBJjyNsryvXpEbBXzAoQNvBE14PXONKfVbVkPneUZhkMc4Xd+OkglSGss+Fv3GRW6Z+zGhLGuqJHNjEmDZS2+aWSl9bRXui2F3pxMvy9cg+dLlsT65kEg882TIQQEOnyufCP84mu5iCPiSAoV+XAxARDTuWgJ00cCzJuoH8HNYFQKuKeh68UHHJ3wNLsdND5Di3mKAoFmqszthYBCkjzv2z5anQOeyJ+e2+HJ9CREGQLegTWP2JykRN0o9Olt5i4mTPGT6uIJXgtw5s4eSkYS/jO9hX6uptTIPx7mjNg3gLDHJ8XUchQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wy35sV/neLBKXRnQ6KFUsrLFfSYFi7/h2N7cM5WF7aM=;
 b=y6eEYPQGuDih1v49NaDY0XfzAmhXUF8Ouo/Pupj8VAJrG1+hdJ2d10TBj+mrCzpNo0Ra0XeaKFZjCsQdlvQ5oxhuM/XKKeO6BxvHFSk/SrStVTpcupgT3QUY0iuBv48H1HUex7Tp2Gtalh6T2goaMNA2S5OHmT2a3iylrUw2Tpgfzu2HdImh8p+TqaFwv2ZNWEez8G1nzHXp/fJTyIbEZb349SiJlV732D7LwT0MHI+yKzga5DVGBQ1uqMP7ZXP4L+NsPk6q8cCfc05J7jWNSvZOCpzXpB2RfjG3gJxuEn2nWIqUBzzJIO6KEo/aBfaGxZbbn4MJt7cl53mNjsqo+g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wy35sV/neLBKXRnQ6KFUsrLFfSYFi7/h2N7cM5WF7aM=;
 b=FqxrEqVEsT2iGdkIBxXL3ZVSK+ssubmi1mThZzaIViH+lhGbxNtO17PykMJr4ONDOy8irsoMQKHYqRwJ6oLVzZCDQxIW9+HQ0Itm8nESDdEq7EDSdstRD/KSbcel5qFQv6X3k/uwxstzgjijYec0Is2DhATZONFCrPz0b6tCuYk=
Received: from CWLP123CA0255.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:19e::23)
 by DB3PR08MB8820.eurprd08.prod.outlook.com (2603:10a6:10:438::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 17:31:18 +0000
Received: from AMS0EPF0000019A.eurprd05.prod.outlook.com
 (2603:10a6:400:19e:cafe::e0) by CWLP123CA0255.outlook.office365.com
 (2603:10a6:400:19e::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Wed,
 18 Mar 2026 17:31:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019A.mail.protection.outlook.com (10.167.16.246) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Wed, 18 Mar 2026 17:31:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sye6Fx9Jzeqya2a+nvQDJqBrUpvIH2RUU3mb8lgXxp8fYPjqUh0ok6VzHDEUD1jzjzehID+8LFeHv9z6OzE1R7SR357+uvRSgfeUK/nXdWTYMb/hOMgLLffXEz42DfOo9jm4rgGi2BaS5ddzf/4Pvp81BeO9iOXA4wDnZseD3fWQLiBdHpT9qDbwq+UDrZ4Zy5vDB+3y3PDfeCJGnVRfp0L1hyrRXF6MYWNLx92gO/oErYGFLcFhKN9oCQ3Z5G/co2WmObyqqFs7fKW0IpOj781lwvgsVtUjj7d8V/xmTR84/bjluaxkqBKWOopZc+hzEGkQJZ4F2lF98Gb6xtq35Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wy35sV/neLBKXRnQ6KFUsrLFfSYFi7/h2N7cM5WF7aM=;
 b=WMgjCQ5u6iopOSy3/ROw0deROko/M0iyChnur40IszsxIaydfQ8EH8/4o6Z4GTsU5ZODGbHParzQzPxuSBHm8ke0KFv8mz+DpMpWLQUNS8QrIx5L499M76JdfN5PUbjhwJA4xpr1gRnXkpVaxJY9W+ZZSgKOcwIKFLzfoDHaZqWhiEY9zaw1kfEV2iLQM6kF2c/FBfGSrbkoZWGlsjyvkV9+rwGjD/FNJG1KJ6MY6Ylf+ef8X1s4qmusQeKUJ/kDkZR33oMg+/nu3wpsMovmGDvAMMyKGas0g3CSbc09jKvCQ3SvbLu5mxHA8Zo1F9dqdoCScOQouhxm+wgmw2UguQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wy35sV/neLBKXRnQ6KFUsrLFfSYFi7/h2N7cM5WF7aM=;
 b=FqxrEqVEsT2iGdkIBxXL3ZVSK+ssubmi1mThZzaIViH+lhGbxNtO17PykMJr4ONDOy8irsoMQKHYqRwJ6oLVzZCDQxIW9+HQ0Itm8nESDdEq7EDSdstRD/KSbcel5qFQv6X3k/uwxstzgjijYec0Is2DhATZONFCrPz0b6tCuYk=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA6PR08MB10567.eurprd08.prod.outlook.com (2603:10a6:102:3cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 18 Mar
 2026 17:30:13 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 17:30:13 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH v6 04/39] KVM: arm64: vgic: Split out mapping IRQs and
 setting irq_ops
Thread-Topic: [PATCH v6 04/39] KVM: arm64: vgic: Split out mapping IRQs and
 setting irq_ops
Thread-Index: AQHctgLsKb0ahtEcF0iWZkW15dw4RrWy4nQAgAGrQQA=
Date: Wed, 18 Mar 2026 17:30:12 +0000
Message-ID: <332f92f0964cd567704757958d02164c01df7f17.camel@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
	 <20260317113949.2548118-5-sascha.bischoff@arm.com>
	 <86jyva5ttz.wl-maz@kernel.org>
In-Reply-To: <86jyva5ttz.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|PA6PR08MB10567:EE_|AMS0EPF0000019A:EE_|DB3PR08MB8820:EE_
X-MS-Office365-Filtering-Correlation-Id: a8092715-3c63-4a4b-8253-08de85142968
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|56012099003|22082099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 tgppbx8Fb1bFFkleQq/7jWQD4a5b4evS3Z3hEYTKj8CaKsxIp0qBi6m+R/qyznjTLJj74G/bGJA71EY6PVpDCIS7ICdLXbvqI7akkSZcETlD9p2phwzpYJgW471L9aP4AKaB4I7gHMH0Gl69k3rhy1h9TiRg+hnsA5g0t+HG8FtYXGfQeelVig9xMcmqNCjyI21ehzYMNuEG/Ms9Z/jCBcs5Xjyl9gOJcT1PAWtwSZZ5sAL6W+x5u3kmHEwQQmrJC+RHBO93lqkJ30TzlxNg1D3PSI5yFIypLdpZxMMM05Pwz9RvbjUzBiqOVP8WqybSjrTl17bruah5mkDAD2b66FSFzH2j61vCNcCwCM1Oxp6LLZuwy4RuqTrd9g8D/Zpm4CQqq5mH4sU1q42zgrv3hQqrW4FzyOiCfWu9BO4oIZ3/mV6+ucUs5IX6jesGIGlhHeUOrc1l/wS/4hauSjsrXKOYaRdrt6bNawwDbBXCyMyYICvXyQWZNLaNnSmnSTtPOISE94K5cbWKEFnYp0hzLX8EjXVJY+EbvH9U5ayFPPw73xmXcYuk7KzQnxGWv6374GuaxaT0g9hKFNIw91UN1b5aylz8q+FPpNaA2BdyIDmeY8/RoxBEQvcm+pFd+BsQN/TkPxPyo6vgnmKd0FGnICmJNIl8DsCQUZ/4s4Hv2eXKyLPqCC9J2Wy5yFaqd+p0yDxVOVHS3nX/KvYRjnDP2YFGELSEYBoiAq7zaKhFHVvC1LWhKhIOkeucP++MJDtmGrBlc/ZW1+ZDtUCNNTnHC6IA7DV8omOiqJ/1QjqQeoE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC52D82AAA320347AAA4CAF6C28A314B@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 jIrg2preDW0I28stzCnz0vM9zps0J2z2Am4xxCDWl2nbaleZhS5hlgzhcJQriGoSxugZMHp+6gelXLbPg49cnW0TLnCP1491tC6h1L9fFQVlOaXoGBvDxj6Bc/v4mnFxuaVUKUpuKQDMbSax4x2q8SuMZS/eET2dmnt9IH2nb77hxuw7SaIC2jBZ+DG1OIZUG3m76qa/OclwgbGTvEQ1ghsBESRt6S/EtYhH2M3oycglbdbFtY5t72Gk83BMz1T9iHiu80lErLe3W1OEdOLEK0VaiANwfBbSGTmqDlAM4/aA93UIoF/9EcEVMNx2+VI18sia0hZjjYVIW9yVkZm0tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10567
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000019A.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7ea783ed-cf31-4aa9-49cf-08de85140302
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|14060799003|1800799024|36860700016|35042699022|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xEK/I4RMO+4jeUEUe0k6m1C/nnRURyUNVnHiYnvE8bi0quJeYlfto49dHN2bEQNz96O1BYwLmfYoyLgLvJfwjV7K3niDGDS+UBayKLRjEZDNe8vZ6R5COjJC7s2FS1ZVFCRwRqvTBTIQnsrRiBHNY4F2MWa4etm2sDLZ3//nLHMp3jEG6V3KHD2EJ6WAvlv/1ZXC5Xj7glr1gBLI0fXgOQzItG+gh7HZbp8e88bir+xgf+MY8w+NCoER9UQa5ee+FU0hbwaopAWQ7I91fL85JUIDfpete8NogopMurxfvnWNlDuLv0JUijGNG955A83r72x2ECSn0PrinaDZdELDBuzuzU24i5gqDn0WUZLeHFXf3+Kivf8kwU8mhjVf9d4P22y/l/J4vVtMUSBwED7kDfL087Z5sRIvjeQ4JTnsVfwr+W/A3BE+pFprE1Hkye9NYPD9yG6+eyyeBiHUhlVgdDYisDhEKu5wRlwNA5fEyqzxOquPFXec6Nx7V7MaJYr9G3+rAsd3jgrusWm6Uh3OR5GAQqcs4nTY39QWCYn5Wawxy1687Vv2Rez7yRE/0M7XU36quHM/owmKxoC4eemCNj7MU2/be58+TbTK182kFC+fvoKMn+9D9APxpCvMIyhBWkvKHJM/BZ8vbTcwInqn1WEajx58iCyccAXtvvdQbp09I995tytPFRsyX22KylT5gLz4/m1s3ELU9po6m/6C6Pm5DUaZVo4bITs8W7bUxhg9Kyll7F+iXYo7SygaAUvlyxTTUzmSJV2MdwLLwpmcHQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(14060799003)(1800799024)(36860700016)(35042699022)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	s86txt7SnTSZgp7Ke0Icnor5kFPGfu0C8aixXXWfyMVZxy82fygKH8BcJR+MGSjB9vsA8S49Rc2wJAjQoju6NNqdIo4iHfcbvLhoFBHcCaiXm9Ye/rhLxS/c29Va0Vw9Grdd2GQDeBMomFCXw+2yT/JgVc0Os06i0gDPVi1U2dXCEi4BcgrR11bBHRU+DznzgY2A5/SX5tJLbLyPqGf4eChbiEB9DA4PM5Tvxa6eyNPxMM5WKet6PbqbERHmbm/O9DPuepCbffoCaYRJXWT0Nw7vHur5U3akjlYOA5U6md/XDMrWU/632laUgRGPbsNycliImOOj6SeqRb/Eex7ILYPXA6QIdrsX58lbvsmNsfzvaBMw771MN7lEVut24FoMEhOOQab1WleTAE+xQy/8tLhb4yJ2MVcMltpyOyD2JPxBR1ger83AL/lA0aYTlWGP
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 17:31:17.2594
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8092715-3c63-4a4b-8253-08de85142968
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019A.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB8820

T24gVHVlLCAyMDI2LTAzLTE3IGF0IDE2OjAwICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIFR1ZSwgMTcgTWFyIDIwMjYgMTE6NDA6NTkgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IFByaW9yIHRvIHRoaXMg
Y2hhbmdlLCB0aGUgYWN0IG9mIG1hcHBpbmcgYSB2aXJ0dWFsIElSUSB0byBhDQo+ID4gcGh5c2lj
YWwNCj4gPiBvbmUgYWxzbyBzZXQgdGhlIGlycV9vcHMuIFVubWFwcGluZyB0aGVuIHJlc2V0IHRo
ZSBpcnFfb3BzIHRvIE5VTEwuDQo+ID4gU28NCj4gPiBmYXIsIHRoaXMgaGFzIGJlZW4gZmluZSBh
bmQgaGFzbid0IGNhdXNlZCBhbnkgbWFqb3IgaXNzdWVzLg0KPiA+IA0KPiA+IE5vdywgaG93ZXZl
ciwgYXMgR0lDdjUgc3VwcG9ydCBpcyBiZWluZyBhZGRlZCB0byBLVk0sIGl0IGhhcyBiZWNvbWUN
Cj4gPiBhcHBhcmVudCB0aGF0IGNvbmZsYXRpbmcgbWFwcGluZy91bm1hcHBpbmcgSVJRcyBhbmQN
Cj4gPiBzZXR0aW5nL2NsZWFyaW5nDQo+ID4gaXJxX29wcyBjYW4gY2F1c2UgaXNzdWVzLiBUaGUg
cmVhc29uIGlzIHRoYXQgdGhlIHVwY29taW5nIEdJQ3Y1DQo+ID4gc3VwcG9ydCBpbnRyb2R1Y2Vz
IGEgc2V0IG9mIGRlZmF1bHQgaXJxX29wcyBmb3IgUFBJcywgYW5kIHJlbW92aW5nDQo+ID4gdGhp
cyB3aGVuIHVubWFwcGluZyB3aWxsIGNhdXNlIHRoaW5ncyB0byBicmVhayByYXRoZXIgaG9ycmli
bHkuDQo+ID4gDQo+ID4gU3BsaXQgb3V0IHRoZSBtYXBwaW5nL3VubWFwcGluZyBvZiBJUlFzIGZy
b20gdGhlIHNldHRpbmcvY2xlYXJpbmcNCj4gPiBvZg0KPiA+IGlycV9vcHMuIFRoZSBhcmNoIHRp
bWVyIGNvZGUgaXMgdXBkYXRlZCB0byBzZXQgdGhlIGlycV9vcHMNCj4gPiBmb2xsb3dpbmcgYQ0K
PiA+IHN1Y2Nlc3NmdWwgbWFwLiBUaGUgaXJxX29wcyBhcmUgaW50ZW50aW9uYWxseSBub3QgcmVt
b3ZlZCBhZ2FpbiBvbg0KPiA+IGFuDQo+ID4gdW5tYXAgYXMgdGhlIG9ubHkgaXJxX29wIGludHJv
ZHVjZWQgYnkgdGhlIGFyY2ggdGltZXIgb25seSB0YWtlcw0KPiA+IGVmZmVjdCBpZiB0aGUgaHcg
Yml0IGluIHN0cnVjdCB2Z2ljX2lycSBpcyBzZXQuIFRoZXJlZm9yZSwgaXQgaXMNCj4gPiBzYWZl
DQo+ID4gdG8gbGVhdmUgdGhpcyBpbiBwbGFjZSwgYW5kIGl0IGF2b2lkcyBhZGRpdGlvbmFsIGNv
bXBsZXhpdHkgd2hlbg0KPiA+IEdJQ3Y1DQo+ID4gc3VwcG9ydCBpcyBpbnRyb2R1Y2VkLg0KPiA+
IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhc2NoYSBCaXNjaG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFy
bS5jb20+DQo+ID4gLS0tDQo+ID4gwqBhcmNoL2FybTY0L2t2bS9hcmNoX3RpbWVyLmMgfCAzMiAr
KysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tDQo+ID4gwqBhcmNoL2FybTY0L2t2bS92Z2lj
L3ZnaWMuY8KgIHwgMzggKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tDQo+ID4gLS0t
LQ0KPiA+IMKgaW5jbHVkZS9rdm0vYXJtX3ZnaWMuaMKgwqDCoMKgwqAgfMKgIDUgKysrKy0NCj4g
PiDCoDMgZmlsZXMgY2hhbmdlZCwgNTUgaW5zZXJ0aW9ucygrKSwgMjAgZGVsZXRpb25zKC0pDQo+
ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2FyY2hfdGltZXIuYw0KPiA+IGIv
YXJjaC9hcm02NC9rdm0vYXJjaF90aW1lci5jDQo+ID4gaW5kZXggNjAwZjI1MDc1M2I0NS4uMWY1
MzZkZDU5NzhkNCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9hcmNoX3RpbWVyLmMN
Cj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS9hcmNoX3RpbWVyLmMNCj4gPiBAQCAtNzQwLDE0ICs3
NDAsMTcgQEAgc3RhdGljIHZvaWQNCj4gPiBrdm1fdGltZXJfdmNwdV9sb2FkX25lc3RlZF9zd2l0
Y2goc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiA+IMKgDQo+ID4gwqAJCXJldCA9IGt2bV92Z2lj
X21hcF9waHlzX2lycSh2Y3B1LA0KPiA+IMKgCQkJCQnCoMKgwqAgbWFwLT5kaXJlY3RfdnRpbWVy
LQ0KPiA+ID5ob3N0X3RpbWVyX2lycSwNCj4gPiAtCQkJCQnCoMKgwqAgdGltZXJfaXJxKG1hcC0N
Cj4gPiA+ZGlyZWN0X3Z0aW1lciksDQo+ID4gLQkJCQkJwqDCoMKgICZhcmNoX3RpbWVyX2lycV9v
cHMpOw0KPiA+IC0JCVdBUk5fT05fT05DRShyZXQpOw0KPiA+ICsJCQkJCcKgwqDCoCB0aW1lcl9p
cnEobWFwLQ0KPiA+ID5kaXJlY3RfdnRpbWVyKSk7DQo+ID4gKwkJaWYgKCFXQVJOX09OX09OQ0Uo
cmV0KSkNCj4gPiArCQkJa3ZtX3ZnaWNfc2V0X2lycV9vcHModmNwdSwgdGltZXJfaXJxKG1hcC0N
Cj4gPiA+ZGlyZWN0X3Z0aW1lciksDQo+ID4gKwkJCQkJwqDCoMKgwqAgJmFyY2hfdGltZXJfaXJx
X29wcyk7DQo+ID4gKw0KPiA+IMKgCQlyZXQgPSBrdm1fdmdpY19tYXBfcGh5c19pcnEodmNwdSwN
Cj4gPiDCoAkJCQkJwqDCoMKgIG1hcC0+ZGlyZWN0X3B0aW1lci0NCj4gPiA+aG9zdF90aW1lcl9p
cnEsDQo+ID4gLQkJCQkJwqDCoMKgIHRpbWVyX2lycShtYXAtDQo+ID4gPmRpcmVjdF9wdGltZXIp
LA0KPiA+IC0JCQkJCcKgwqDCoCAmYXJjaF90aW1lcl9pcnFfb3BzKTsNCj4gPiAtCQlXQVJOX09O
X09OQ0UocmV0KTsNCj4gPiArCQkJCQnCoMKgwqAgdGltZXJfaXJxKG1hcC0NCj4gPiA+ZGlyZWN0
X3B0aW1lcikpOw0KPiA+ICsJCWlmICghV0FSTl9PTl9PTkNFKHJldCkpDQo+ID4gKwkJCWt2bV92
Z2ljX3NldF9pcnFfb3BzKHZjcHUsIHRpbWVyX2lycShtYXAtDQo+ID4gPmRpcmVjdF9wdGltZXIp
LA0KPiA+ICsJCQkJCcKgwqDCoMKgICZhcmNoX3RpbWVyX2lycV9vcHMpOw0KPiANCj4gRG8gd2Ug
cmVhbGx5IG5lZWQgdGhpcyBlYWdlciBzZXR0aW5nIG9mIG9wcz8gR2l2ZW4gdGhhdCBub3RoaW5n
IHNlZW1zDQo+IHRvIGNsZWFyIHRoZW0sIHdoeSBjYW4ndCB3ZSBqdXN0IHNldCB0aGUgb3BzIGF0
IHZjcHUgaW5pdCB0aW1lPyBHaXZlbg0KPiB0aGF0IHRoaXMgaXMgYSBwcmV0dHkgaG90IHBhdGgg
KG9uIGVhY2ggZXhjZXB0aW9uL2V4Y2VwdGlvbiByZXR1cm4NCj4gYmV0d2VlbiBMMiBhbmQgTDEp
LCB0aGUgbGVhc3Qgd2UgZG8gaGVyZSwgdGhlIGJldHRlci4NCg0KSG1tLCBJIHRoaW5rIHlvdSdy
ZSByaWdodC4gV2hlbiBtYWtpbmcgdGhpcyBjaGFuZ2UsIEkgd2FzIHRyeWluZyB0bw0KcHJlc2Vy
dmUgdGhlIGV4aXN0aW5nIGJlaGF2aW91ciBzbyBzZXQgdGhlIGlycV9vcHMgZm9yIGVhY2ggbWFw
IGNhbGwuDQpIb3dldmVyLCBhcyB5b3Ugc2F5IG5vdGhpbmcgaXMgY2xlYXJpbmcgdGhlIG9wcyAo
YXMgdGhpbmdzIHN0YW5kLCBhdA0KbGVhc3QpLCBzbyB0aGF0IGRvZXMgaW5kZWVkIG1ha2Ugc2Vu
c2UgdG8gZG8gSU1PLg0KDQo+IA0KPiA+IMKgCX0NCj4gPiDCoH0NCj4gPiDCoA0KPiA+IEBAIC0x
NTY1LDIwICsxNTY4LDIzIEBAIGludCBrdm1fdGltZXJfZW5hYmxlKHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSkNCj4gPiDCoA0KPiA+IMKgCXJldCA9IGt2bV92Z2ljX21hcF9waHlzX2lycSh2Y3B1LA0K
PiA+IMKgCQkJCcKgwqDCoCBtYXAuZGlyZWN0X3Z0aW1lci0NCj4gPiA+aG9zdF90aW1lcl9pcnEs
DQo+ID4gLQkJCQnCoMKgwqAgdGltZXJfaXJxKG1hcC5kaXJlY3RfdnRpbWVyKSwNCj4gPiAtCQkJ
CcKgwqDCoCAmYXJjaF90aW1lcl9pcnFfb3BzKTsNCj4gPiArCQkJCcKgwqDCoCB0aW1lcl9pcnEo
bWFwLmRpcmVjdF92dGltZXIpKTsNCj4gPiDCoAlpZiAocmV0KQ0KPiA+IMKgCQlyZXR1cm4gcmV0
Ow0KPiA+IMKgDQo+ID4gKwlrdm1fdmdpY19zZXRfaXJxX29wcyh2Y3B1LCB0aW1lcl9pcnEobWFw
LmRpcmVjdF92dGltZXIpLA0KPiA+ICsJCQnCoMKgwqDCoCAmYXJjaF90aW1lcl9pcnFfb3BzKTsN
Cj4gPiArDQo+ID4gwqAJaWYgKG1hcC5kaXJlY3RfcHRpbWVyKSB7DQo+ID4gwqAJCXJldCA9IGt2
bV92Z2ljX21hcF9waHlzX2lycSh2Y3B1LA0KPiA+IMKgCQkJCQnCoMKgwqAgbWFwLmRpcmVjdF9w
dGltZXItDQo+ID4gPmhvc3RfdGltZXJfaXJxLA0KPiA+IC0JCQkJCcKgwqDCoA0KPiA+IHRpbWVy
X2lycShtYXAuZGlyZWN0X3B0aW1lciksDQo+ID4gLQkJCQkJwqDCoMKgICZhcmNoX3RpbWVyX2ly
cV9vcHMpOw0KPiA+IC0JfQ0KPiA+ICsJCQkJCcKgwqDCoA0KPiA+IHRpbWVyX2lycShtYXAuZGly
ZWN0X3B0aW1lcikpOw0KPiA+ICsJCWlmIChyZXQpDQo+ID4gKwkJCXJldHVybiByZXQ7DQo+ID4g
wqANCj4gPiAtCWlmIChyZXQpDQo+ID4gLQkJcmV0dXJuIHJldDsNCj4gPiArCQlrdm1fdmdpY19z
ZXRfaXJxX29wcyh2Y3B1LA0KPiA+IHRpbWVyX2lycShtYXAuZGlyZWN0X3B0aW1lciksDQo+ID4g
KwkJCQnCoMKgwqDCoCAmYXJjaF90aW1lcl9pcnFfb3BzKTsNCj4gPiArCX0NCj4gDQo+IHdoaWNo
IHdvdWxkIG1lYW4gbW92aW5nIHRoaXMgdG8ga3ZtX3RpbWVyX3ZjcHVfaW5pdCgpLg0KDQpUaGlz
LCBob3dldmVyLCBpcyBub3QgcXVpdGUgdGhhdCBzaW1wbGUuDQoNCkl0IHR1cm5zIG91dCB0aGF0
IHdlIGFjdHVhbGx5IGNhbGwga3ZtX3RpbWVyX3ZjcHVfaW5pdCgpIGJlZm9yZQ0Ka3ZtX3ZnaWNf
dmNwdV9pbml0KCkgZnJvbSBrdm1fYXJjaF92Y3B1X2NyZWF0ZSgpLCBtZWFuaW5nIHRoYXQgd2Ug
ZG9uJ3QNCmhhdmUgdGhlIHByaXZhdGUgSVJRcyBhbGxvY2F0ZWQuDQoNCklzIHRoZXJlIGEgZ29v
ZCByZWFzb24gdGhhdCB0aGUgdGltZXIgKGFuZCBQTVUpIGFyZSBpbml0aWFsaXNlZCBwcmlvcg0K
dG8gaW5pdGlhbGlzaW5nIHRoZSBDUFU/DQoNCkkndmUgdHJpZWQgbWFraW5nIHRoaXMgY2hhbmcs
IGFuZCBvbmNlIEkgcmVvcmRlciB0aGUgdGltZXIgYW5kIHZjcHUNCmluaXRpYWxpc2F0aW9uIEkg
Y2FuIGNvbmZpcm0gdGhhdCB0aGluZ3Mgd29yayB3aXRoIGFuZCB3aXRob3V0IG5lc3RlZC4NCg0K
PiANCj4gPiDCoA0KPiA+IMKgbm9fdmdpYzoNCj4gPiDCoAl0aW1lci0+ZW5hYmxlZCA9IDE7DQo+
ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5jDQo+ID4gYi9hcmNoL2Fy
bTY0L2t2bS92Z2ljL3ZnaWMuYw0KPiA+IGluZGV4IGUyMmI3OWNmZmY5NjUuLmUzN2M2NDBkNzRi
Y2YgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCj4gPiArKysg
Yi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuYw0KPiA+IEBAIC01NTMsMTAgKzU1MywzOCBAQCBp
bnQga3ZtX3ZnaWNfaW5qZWN0X2lycShzdHJ1Y3Qga3ZtICprdm0sDQo+ID4gc3RydWN0IGt2bV92
Y3B1ICp2Y3B1LA0KPiA+IMKgCXJldHVybiAwOw0KPiA+IMKgfQ0KPiA+IMKgDQo+ID4gK3ZvaWQg
a3ZtX3ZnaWNfc2V0X2lycV9vcHMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1MzIgdmludGlkLA0K
PiA+ICsJCQkgc3RydWN0IGlycV9vcHMgKm9wcykNCj4gPiArew0KPiA+ICsJc3RydWN0IHZnaWNf
aXJxICppcnEgPSB2Z2ljX2dldF92Y3B1X2lycSh2Y3B1LCB2aW50aWQpOw0KPiA+ICsNCj4gPiAr
CUJVR19PTighaXJxKTsNCj4gPiArDQo+ID4gKwlzY29wZWRfZ3VhcmQocmF3X3NwaW5sb2NrX2ly
cXNhdmUsICZpcnEtPmlycV9sb2NrKQ0KPiA+ICsJew0KPiA+ICsJCWlycS0+b3BzID0gb3BzOw0K
PiA+ICsJfQ0KPiANCj4gbml0OiBvcGVuaW5nIGJyYWNlIGluIHRoZSB3cm9uZyBzcG90LCBhbmQg
b3ZlcmFsbCBub3QgdXNlZnVsLiBUaGlzDQo+IGNvdWxkIHNpbXBseSBiZSB3cml0dGVuIGFzOg0K
PiANCj4gCXNjb3BlZF9ndWFyZChyYXdfc3BpbmxvY2tfaXJxc2F2ZSwgJmlycS0+aXJxX2xvY2sp
DQo+IAkJaXJxLT5vcHMgPSBvcHM7DQoNCkFyZ2gsIHNvcnJ5IHRoYXQgc2xpcHBlZCB0aHJvdWdo
IQ0KDQo+IA0KPiA+ICsNCj4gPiArCXZnaWNfcHV0X2lycSh2Y3B1LT5rdm0sIGlycSk7DQo+ID4g
K30NCj4gPiArDQo+ID4gK3ZvaWQga3ZtX3ZnaWNfY2xlYXJfaXJxX29wcyhzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUsIHUzMiB2aW50aWQpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCB2Z2ljX2lycSAqaXJx
ID0gdmdpY19nZXRfdmNwdV9pcnEodmNwdSwgdmludGlkKTsNCj4gPiArDQo+ID4gKwlCVUdfT04o
IWlycSk7DQo+ID4gKw0KPiA+ICsJc2NvcGVkX2d1YXJkKHJhd19zcGlubG9ja19pcnFzYXZlLCAm
aXJxLT5pcnFfbG9jaykNCj4gPiArCXsNCj4gPiArCQlpcnEtPm9wcyA9IE5VTEw7DQo+ID4gKwl9
DQo+ID4gKw0KPiA+ICsJdmdpY19wdXRfaXJxKHZjcHUtPmt2bSwgaXJxKTsNCj4gPiArfQ0KPiA+
ICsNCj4gDQo+IG5pdDogdGhhdCBjb3VsZCBhbHNvIGJlIHdyaXR0ZW4gYXM6DQo+IA0KPiB2b2lk
IGt2bV92Z2ljX2NsZWFyX2lycV9vcHMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1MzIgdmludGlk
KQ0KPiB7DQo+IAlrdm1fdmdpY19zZXRfaXJxX29wcyh2Y3B1LCB2aW50aWQsIE5VTEwpOw0KPiB9
DQoNCkFoLCB0aGF0IGlzIGluZGVlZCBjbGVhbmVyLg0KDQo+IA0KPiBJIGNhbiBmaXggYWxsIG9m
IGl0IHdoZW4gYXBwbHlpbmcgaWYgdGhhdCB3b3JrcyBmb3IgeW91Lg0KDQpJZiB5b3UncmUgaGFw
cHkgdG8gZG8gdGhhdCwgdGhhdCBpcyBncmVhdCEgRG8gbm90ZSB3aGF0IEkgc2FpZCBhYm92ZQ0K
cmVnYXJkaW5nIHRoZSBvcmRlciBvZiB2Y3B1IGFuZCB0aW1lciBpbml0IQ0KDQpUaGFua3MsDQpT
YXNjaGENCg0KPiANCj4gVGhhbmtzLA0KPiANCj4gCU0uDQo+IA0KDQo=
