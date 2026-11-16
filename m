Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=40.107.130.40
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794821876;
	b=xPTFFQzUmTMGr2R2GaujjSYoZSDFbnAvaxqD/qfHeWMvYaJj3bh68PO3WwzqrO5FrR1Q
	 re21jiin9VR+CxODBebkfmYHWp50heF+xuG5wyzjpdcGKBDKk+Yo0+Xs6YZ4/IgnBqWlZ
	 GmrQGCy1ePuHKYpmDHNywvwAbEzM6ldubOmRxTWSQwX2wmQkY3XtUcQeiYbzhgESvoCfv
	 eHajEs2/sqTH8myQ6TOKs4HkI+kzgoPwwZ6otFFyb39c/0wwJHsdTE5ha339Cm2uPTQV2
	 mSt5wgqBKvSVyp6OK6k0hREhom6+gm4m64uWvv/GGLjfWDG+r5EVnve1PNM0KWiA4KA==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794821876;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:
	 DKIM-Signature:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 Authentication-Results-Original:x-ms-traffictypediagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:x-checkrecipientrouted:
	 nodisclaimer:X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam-Untrusted:
	 X-Microsoft-Antispam-Message-Info-Original:
	 X-Forefront-Antispam-Report-Untrusted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-EOPAttributedMessage:
	 X-MS-Exchange-Transport-CrossTenantHeadersStripped:
	 X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id-Prvs:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=may/rOQSAJz/oFkXcQmP3DqeV+p1Co0EWjv4Y8ymI/o=;
	b=sWDOnkM/oIIGH2UpZy3IRRgLLXCUAXAZ73/uY+WhQyIh47XxeK1aWSxeJfADeCL5FwQL
	 hk1GpNsdn2yCskqfw34hGLTL/QFqiheOyX+GdGx73tuQUtwcjM5VfvkzCexg2mrPzsmJr
	 U6GcM7z35M8J2iGJKUewIlGm/7OIkDMudeAYzs2YA2teMfeFsybTXbIV64medOVKNwdzP
	 hcRhxwrTNEQojSf+4Wdx2kBNRfMpJpAT1mkSEt5Nb7IJksfiu7zHs1gRkZfLteVtbwgVS
	 tTRVnY0C43XWqU6JoBrxA0mf6NKQqfHFmnvnYWEdvq6DSHRx777lneSbvP3tyea1UWg==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=mUIrEYm2;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=mUIrEYm2;
	arc=pass header.oldest-pass=2 smtp.remote-ip=40.107.130.40
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011040.outbound.protection.outlook.com [40.107.130.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F85606A323;
	Mon, 16 Nov 2026 09:37:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77F85606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=mUIrEYm2;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=mUIrEYm2
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=EynG0GOEbJdUJOkx9bBHd3DHHJawEYqxv7Zl1SFaXDbv/QjRlCZr7FW9EuVEiGxO2jHQsm3sixtPp5u9xmjIm4ng8pwKeJsiEwf+IPn7jXVyg8qGnxMe17lTD2YyEaifRY4x5QFZ9r6W7q9yHgrKBqE/DDzw7niHEWt+iUCJB9b7YWkrliD18BksCDjVAgC8YbFYD5+ySwOfuthZcZo/fAQlKYf2fL8YLDRLsda3aE+Ku3nzFdMF2sk7iKn+seMbwM4SIEdY5SH7l8L/iOoZYV/1QF/uzukuXE1gbELJi1XbTDZ1RxeI1jFYO2qcq7ANjcpLRaV//7j7QJwmAyIA6A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=may/rOQSAJz/oFkXcQmP3DqeV+p1Co0EWjv4Y8ymI/o=;
 b=pRI9WV7APrm/XuI+PQ/R3M0SQ4QLRf4i1VRQBYa41cMLa0CBVIfCW7R4780mtsT/dev5deBc9gJAz3Lv5zXVcrN8Wvd2hzI5qAARjCKs+BYb/kpO7dTrjnr2JGBWna2Fl9tsXucbT6MDv+9GSGwMXymzQefc2KXGEHd+6d3ZqRrQa9gVztB1MLfUrivU0qD2iEP5GjAPd4IaOZgeE4RIx9NPneEonFJaLdRpY8W3npSIKnWsQE9eCneQh8YQBnr3uiakP3dopGBFGtoCtnrjwO4w5OHeDlxr/1u09t1vvUJA3nGxvHm5GXEaWiRB9kABW9xYI1w9hFTn1tOjVYL8YQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=may/rOQSAJz/oFkXcQmP3DqeV+p1Co0EWjv4Y8ymI/o=;
 b=mUIrEYm215BvhRtJPQK1vC64djjp2XfeVejKozPhfg6+HncnP9XRv5hwwVgacmpvtCus2XqXSHjiIscDLFQ/qaNndnTLSCgDGEGZLtMAGfz1hXm4bRStRuMhkF3OrK0bO3DGipjKf4IetIfAPV79ZY+tTGUsWvpYU+FiwBhlYJw=
Received: from AS4PR10CA0005.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5dc::13)
 by AM0PR08MB041735.eurprd08.prod.outlook.com (2603:10a6:20b:807::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 09:37:50 +0000
Received: from AMS0EPF00000566.eurprd02.prod.outlook.com
 (2603:10a6:20b:5dc:cafe::a7) by AS4PR10CA0005.outlook.office365.com
 (2603:10a6:20b:5dc::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Mon,
 16 Nov 2026 09:37:50 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000566.mail.protection.outlook.com (10.167.242.116) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.4
 via Frontend Transport; Mon, 16 Nov 2026 09:37:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pHM02VV87IUT/xUnvMpxbmbvsDkQgc5mjZ5YlRrr6f+Fuj0tPBdaeeIG70BuxAwYyu2/vUebYHsAaVlTRct2uj9GMYyuEs619ULXcAfoWBqWRW5S8mU03hkbGaEVsoyE4hlj2yug0LqS19Un2GPEX6cDD8Aw5+aP6ROuO+1+4ANbRs5S8/PS3b4CU3nj89GiVTBnRve2AZKyFjQ4gSc2xuWq83FjCyaX2P9ZmsETlot2PbYbRSxSIRY9vDI6iEHuddAaFLnDJwjO9R/Yl0GUb8zIX6hmjteNSqeOTTvl3EMmykoWlo/XTQvpLATFBTzmNZb/EqIPA8XWZbHgHJXwZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=may/rOQSAJz/oFkXcQmP3DqeV+p1Co0EWjv4Y8ymI/o=;
 b=xEQjN2aK5cgUP+rzQ8pfBG19HIxwTQOsPaC+GMKwqFSCtVzsh/ajIywVe2BblqYhksxVMbe3gAgTt8/eu9Qm7cSasIZFiy6IHJURJs4f+3kt//8Z7H9uBdgA98Mg7fMo2i90+1rQC3wNK2fI0XWekoPfyLv/oFVdMBPl65iQ1M5UQ1LVZD5+F/zHfBTL7gm+Go9YF/ZoVlzkcz+1DX9O7t5/rIAfSlFwxc8FfnXBxPVddoLL3GWv6Yg9aXReGvVYIZuO280dXxu83Ra/xNabkmxYM1AiYXTRr5uMujDF4JLRUH2ZCnhEjVsnfVk0pS8VG+IURaF4jUpQxQZAZBPwIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=may/rOQSAJz/oFkXcQmP3DqeV+p1Co0EWjv4Y8ymI/o=;
 b=mUIrEYm215BvhRtJPQK1vC64djjp2XfeVejKozPhfg6+HncnP9XRv5hwwVgacmpvtCus2XqXSHjiIscDLFQ/qaNndnTLSCgDGEGZLtMAGfz1hXm4bRStRuMhkF3OrK0bO3DGipjKf4IetIfAPV79ZY+tTGUsWvpYU+FiwBhlYJw=
Received: from AS2PR08MB9786.eurprd08.prod.outlook.com (2603:10a6:20b:605::22)
 by GVXPR08MB11609.eurprd08.prod.outlook.com (2603:10a6:150:323::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 09:37:14 +0000
Received: from AS2PR08MB9786.eurprd08.prod.outlook.com
 ([fe80::d721:dfdb:2f83:155]) by AS2PR08MB9786.eurprd08.prod.outlook.com
 ([fe80::d721:dfdb:2f83:155%6]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 09:37:14 +0000
From: Justin He <Justin.He@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-rt-devel@lists.linux.dev" <linux-rt-devel@lists.linux.dev>, Oliver
 Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] KVM: arm64: gic-v5: Don't move the vPE doorbell from
 kvm_sched_out()
Thread-Topic: [PATCH 2/2] KVM: arm64: gic-v5: Don't move the vPE doorbell from
 kvm_sched_out()
Thread-Index: AQHddZoBmBXfR6k8IU2/XAv726hrlrcwV8oAgAAXfSA=
Date: Mon, 16 Nov 2026 09:37:14 +0000
Message-ID:
 <AS2PR08MB97868A5CE01B18481E9549E0F77C2@AS2PR08MB9786.eurprd08.prod.outlook.com>
References: <20261116071304.2037895-1-justin.he@arm.com>
 <20261116071304.2037895-3-justin.he@arm.com>
 <sashiko-outbox-216506@kernel.org>
In-Reply-To: <sashiko-outbox-216506@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS2PR08MB9786:EE_|GVXPR08MB11609:EE_|AMS0EPF00000566:EE_|AM0PR08MB041735:EE_
X-MS-Office365-Filtering-Correlation-Id: 38960dc2-2a89-41a4-5f69-08df43c547fc
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|18002099003|22082099003|261009223027099003|4143699003|11063799006|56012099006|5023799004|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261022105027099003|261021121427099003|261022075727099003|38070700021|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 05d5kIv2Fw80Q2KmmoirTYYmr4eL8QVQa3L2sdKjzvnq+oNVj0ByvdrVEuTvJraYWdTnQZfVbvWe6yQ5TWZ0So1md0rR2pesqjHGPXz9In4MYFguCtsM7BDrpk2ztaSLlYwryFudr6cgAxr36spylYp6GXiFV9nqm8oJxK2s9gpsf77O8dg4GQHfGjHAA5hXs437c43ln4Sb7G+kZFMAE1QNGendQ+PfYfn3xdR3bn8588sa0/IXWLhXtlIwJjPuuKVsoNpG/KpmBNEl/RKjlJRKXkc0CN7jJHVYMyCP9pZmXslJY/iWVivsd4PZkk6hy1Vk1jNQdhL5119rPvrx2bPq9ysXSS9PFMs7QraEwQkIQ6zNglR7C8itXkegxjTxofmIrDGBt5ycZcWOz8R2Bl892sI1Hw6VV+QBykqrU6XR48GuZy8G0dEAHTQw/h3lnOY1g4OOw/2Vm4cyqlAAn79PhlyMd+JHtDqy0BxWRXYvvzEozgiv0DV2Jppjpixmq7RmVNJkDeQtd0xthRI8wFT1KmOAc52Xi/Tnvi4HPYyRvCXee4u2PzPoBmwAZxtsW+JZ6+A4cizEicJokdvdxxUbc9PaTzta1vCnv/KwGXqOIocgdsn74JhhCxj4gE3io83JzYhvUlL9GL4UlDbw6B+HGNHqdaBSGqcO6csihLS3U99KZkUhTMjPW4iMXXGD+d1gpnezGT+Fb6YLDaWyt3l9y4q7YyBWLOR/5VLFyNA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB9786.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(18002099003)(22082099003)(261009223027099003)(4143699003)(11063799006)(56012099006)(5023799004)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261022105027099003)(261021121427099003)(261022075727099003)(38070700021)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 1lbZ+jQaAGKk65H/OLcYI19nO8ejxU1pbPJxHcvgfB36nOqAn4Vnqup2OfCQszWaWJmcwYpll8NSwTHpFKI3F1WP9PtRx7tv1xT+TJ1syW1GSyVQDKW7SNU6B+HvuSx3eGUgPpZ/kR+ktbD5JNhyOJEtFIHqnNiZh6a9TkiVlNaasv0DIH5oUZC3aj7sbZj7dDFuBpgSJF3V/ELk4oQizFXkuYAqODnHVuf43QHLbPjuTV56L4Himd+KnNH6+f3c3vyLVTdWgjpTMbYEpL32X0afgTprESH646B/1m8a6utNYmVvnsH1pCnmjHVmSDgqxWD9DvMknRUG2x3Q9oqacQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11609
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000566.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	759e61ac-2b0b-4188-c7d4-08df43c532b0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|14060799003|35042699022|1800799024|376014|18002099003|22082099003|261009223027099003|11063799006|5023799004|4143699003|56012099006|261028144727099003|261102123227099003|261026121527099003|261026140227099003|261022075727099003|261022105027099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	G8d6LYj21jvK67NRh6FMFLZD9Zl8tYmToWfskFOqy20BV9itD/Xgz4IL2BdaP66oPNb5rnXpvFmIHfYaAagTop/R58sgpfzcBSvLQKCfeHBk9r1DSUAmkPIgDlpczYKQYNjff138SP0AEmsoLU/QFcEKvpkT0KIS0s8Mfm+2wHxYpGD6TT4ZBWByv5GPeQOjxivJ+CmitBcE4BYKeHzyXZLZ/4UOof0W3sEtGrN4Um7gdsoDRTpA+aSq/cKCel9hx9lPQEBlEnSjl8pyc4+xd6zn4bFlXQ5Yh1AW1Ct3eYvaDW4lYGaDsSDeXup6VIsuizSmYeDLNEexDVgS5oYWqrzSFu2oiKZIaQ5KCpEteCROybSEiKfw+OI1v1Ak5TUuAn2IrrNlKVesp2h66mUXPz79ltSY+GV9DQLVrqZQN+efMjskXvkxv8ZkAk8X5XW7Y6l7tX6L4QhdeYE2rPJJDoG3+tQJ8n/N9+4vnfpp3r+WCrEpM+zUxD2Tk99wEtgGoZB+MDPJyDK2p0uywLBIg8YzVE4xXFZ8Fon8nbEX8WvNcJAD7fCxhZa7URMFtTVWR75WPn4Fwwg5NFWEB74l4/Fjkz/tt1JJZYuxWMZoFyiteFpgA9RigDrrsp1VT47q472yLAKhEf0rbbl8pWeK41ImHkTrOftEZkVsfm23OarVOs7okdzxH0dfrdNydQB1OxWeI3vTiT7MUwyrrY3x/g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(14060799003)(35042699022)(1800799024)(376014)(18002099003)(22082099003)(261009223027099003)(11063799006)(5023799004)(4143699003)(56012099006)(261028144727099003)(261102123227099003)(261026121527099003)(261026140227099003)(261022075727099003)(261022105027099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wx4fgt5Xu1kcFEEyraivbt2yHhXR7Hg0Ikqu/VVIwk+y2dXTCMoSpYdq9u8oeRVZu2dx1PMtrA9PkT62uB/Fg6CWmoF+w/fkPYd/JIuvym/TCQ4rlmGwQQySxPFSgo5sDK5+GR2mar3ccf8fs++3y4Tb5pf7jWs535Pcf7VVy+2Qg3xluCpEvwN8OZ2LYxLCkPil7bU65JxU03Cs0bPxF/K1YLM/XONeEEQFv6KUsk1rps43YTgHKTlmBEsMclbZbBM/J2WXCBwDouKlQ3GycSRrLV+4rGHqwAjYLXdqhm5SZwWrYO4691L3sO7FDnd1SWn4h4IriMda1jPJu64yiGWrmbrxdLBSbt2cf2IRghTCYMBuqmXIJ9AzHrLMVzyGzyQcEnKfc4bm9CZNLmZ0WziWlrA3InxBomv9kCopYTle2plrY/BoJf0RuGM40hyc
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 09:37:50.4082
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38960dc2-2a89-41a4-5f69-08df43c547fc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000566.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB041735

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogc2FzaGlrby1ib3RAa2Vy
bmVsLm9yZyA8c2FzaGlrby1ib3RAa2VybmVsLm9yZz4NCj4gU2VudDogTW9uZGF5LCBOb3ZlbWJl
ciAxNiwgMjAyNiA0OjA3IFBNDQo+IFRvOiBKdXN0aW4gSGUgPEp1c3Rpbi5IZUBhcm0uY29tPg0K
PiBDYzoga3ZtYXJtQGxpc3RzLmxpbnV4LmRldjsgbGludXgtcnQtZGV2ZWxAbGlzdHMubGludXgu
ZGV2OyBPbGl2ZXIgVXB0b24NCj4gPG91cHRvbkBrZXJuZWwub3JnPjsgTWFyYyBaeW5naWVyIDxt
YXpAa2VybmVsLm9yZz47IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggMi8yXSBLVk06IGFybTY0OiBnaWMtdjU6IERvbid0IG1vdmUgdGhlIHZQ
RSBkb29yYmVsbA0KPiBmcm9tIGt2bV9zY2hlZF9vdXQoKQ0KPiANCj4gVGhhbmsgeW91IGZvciB5
b3VyIGNvbnRyaWJ1dGlvbiEgU2FzaGlrbyBBSSByZXZpZXcgZm91bmQgMSBwb3RlbnRpYWwNCj4g
aXNzdWUgdG8gY29uc2lkZXI6DQo+IC0gW01lZGl1bV0gS1ZNOiBhcm02NDogZ2ljLXY1OiB2Z2lj
X3Y1X2xvYWQoKSBpbiBXRkkgZGlzYXJtcyBkb29yYmVsbHMNCj4gICBhbmQgbG9zZXMgd2FrZXVw
cw0KPiAtLQ0KPiANCj4gY29tbWl0IDM2ODQ0Y2RiZGE0ZGYyYjE3N2I2YzAxM2MyMDc0Mjg3ZDc1
ZmY1ZjMNCj4gQXV0aG9yOiBKaWEgSGUgPGp1c3Rpbi5oZUBhcm0uY29tPg0KPiANCj4gS1ZNOiBh
cm02NDogZ2ljLXY1OiBEb24ndCBtb3ZlIHRoZSB2UEUgZG9vcmJlbGwgZnJvbSBrdm1fc2NoZWRf
b3V0KCkNCj4gDQo+IFRoaXMgY29tbWl0IHNraXBzIGNhbGxpbmcgaXJxX3NldF9hZmZpbml0eSgp
IGluIHZnaWNfdjVfcHV0KCkgd2hlbg0KPiB2Y3B1LT5zY2hlZHVsZWRfb3V0IGlzIHNldCwgYXZv
aWRpbmcgYWNxdWlyaW5nIGlycV9kZXNjIGFuZCBwaV9sb2NrIHVuZGVyDQo+IHRoZQ0KPiBydW5x
dWV1ZSBsb2NrIGR1cmluZyBrdm1fc2NoZWRfb3V0KCkuDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9h
cmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12
NS5jDQo+ID4gaW5kZXggOTE4MTBmYmQ5OWFmYS4uNTgyNGIwMGJiNTBkZiAxMDA2NDQNCj4gPiAt
LS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQv
a3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gQEAgLTEyNDgsOCArMTI0OCwxNCBAQCB2b2lkIHZnaWNf
djVfcHV0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiAgCQkJICogTWFrZSB0aGUgZG9vcmJl
bGwgYWZmaW5lIHRvIHRoaXMgQ1BVLCBpZiBpdCBpc24ndA0KPiA+ICAJCQkgKiBhbHJlYWR5LiBB
Y3RpdmVseSBjaGVjayB0aGUgY3B1bWFzayBmaXJzdCBhcyBpdCBpcw0KPiA+ICAJCQkgKiBjaGVh
cGVyIHRoYW4gY2hhbmdpbmcgdGhlIGFmZmluaXR5IGV2ZXJ5IHRpbWUuDQo+ID4gKwkJCSAqDQo+
ID4gKwkJCSAqIERvbid0IGRvIGl0IGZyb20ga3ZtX3NjaGVkX291dCgpLCB3aGljaCBob2xkcyB0
aGUNCj4gPiArCQkJICogcnVucXVldWUgbG9jazogaXJxX3NldF9hZmZpbml0eSgpIHRha2VzIHRo
ZQ0KPiA+ICsJCQkgKiBkb29yYmVsbCdzIGlycV9kZXNjIGxvY2sgYW5kIG1heSB3YWtlIGl0cyBp
cnENCj4gPiArCQkJICogdGhyZWFkLiBUaGUgZG9vcmJlbGwgd29ya3MgZnJvbSBhbnkgQ1BVLCBh
bmQgdGhlDQo+ID4gKwkJCSAqIG5leHQgV0ZJIGVudHJ5IG1vdmVzIGl0Lg0KPiA+ICAJCQkgKi8N
Cj4gPiAtCQkJaWYgKCFjcHVtYXNrX3Rlc3RfY3B1KGNwdSwgYWZmKSkgew0KPiA+ICsJCQlpZiAo
IXZjcHUtPnNjaGVkdWxlZF9vdXQgJiYgIWNwdW1hc2tfdGVzdF9jcHUoY3B1LA0KPiBhZmYpKSB7
DQo+ID4gIAkJCQlpbnQgcmV0Ow0KPiA+DQo+ID4gIAkJCQlyZXQgPSBpcnFfc2V0X2FmZmluaXR5
KGRiX2lycSwNCj4gY3B1bWFza19vZihjcHUpKTsNCj4gDQo+IFtTZXZlcml0eTogTWVkaXVtXQ0K
PiBTaG91bGQgdmdpY192NV9sb2FkKCkgYmFpbCBvdXQgd2hlbiBJTl9XRkkgaXMgc2V0IGluc3Rl
YWQgb2Ygb25seSBza2lwcGluZw0KPiBpcnFfc2V0X2FmZmluaXR5KCkgaGVyZT8NCj4gDQo+IEJl
Y2F1c2UgdmdpY192NV9sb2FkKCkgZG9lcyBub3QgY2hlY2sgdmNwdV9nZXRfZmxhZyh2Y3B1LCBJ
Tl9XRkkpLCBhbnkNCj4ga3ZtX3NjaGVkX2luKCkgd2hpbGUgdGhlIHZDUFUgaXMgaGFsdGluZyBp
biBrdm1fdmNwdV9oYWx0KCkgY2FsbHMNCj4gX192Z2ljX3Y1X21ha2VfcmVzaWRlbnQoKSwgc2V0
dGluZyBnaWN2NV92cGUucmVzaWRlbnQgPSB0cnVlIGFuZCBjbGVhcmluZw0KPiBJQ0hfQ09OVEVY
VFJfRUwyX0RCIGluIGhhcmR3YXJlLg0KPiANCj4gSWYgdGhlIHZQRSBkb29yYmVsbCBmaXJlcyB3
aGlsZSBibG9ja2VkIGluIGt2bV92Y3B1X2Jsb2NrKCksIGRiX2hhbmRsZXIoKQ0KPiBzZXRzIGdp
Y3Y1X3ZwZS5kYl9maXJlZCA9IHRydWUgYW5kIHdha2VzIHRoZSB2Q1BVIHRocmVhZC4gV2hlbiB0
aGUgdGhyZWFkDQo+IHNjaGVkdWxlcyBpbiwgdmdpY192NV9sb2FkKCkgbWFrZXMgdGhlIHZQRSBy
ZXNpZGVudCBiZWZvcmUgc2NoZWR1bGUoKSByZXR1cm5zDQo+IHRvIHRoZSBsb29wIGluIGt2bV92
Y3B1X2Jsb2NrKCkuIElmIHRoZSB2Q1BVIHRocmVhZCBpcyBwcmVlbXB0ZWQgYWdhaW4NCj4gYmVm
b3JlDQo+IGt2bV92Y3B1X2NoZWNrX2Jsb2NrKCkgY29uc3VtZXMgZGJfZmlyZWQsIGt2bV9zY2hl
ZF9vdXQoKSAtPg0KPiB2Z2ljX3Y1X3B1dCgpDQo+IHN0aWxsIGNhbGxzIF9fdmdpY192NV9tYWtl
X25vbl9yZXNpZGVudCgpOg0KPiANCj4gYXJjaC9hcm02NC9rdm0vaHlwL3ZnaWMtdjUtc3IuYzpf
X3ZnaWNfdjVfbWFrZV9ub25fcmVzaWRlbnQoKSB7DQo+IAkuLi4NCj4gCVdSSVRFX09OQ0UoY3B1
X2lmLT5naWN2NV92cGUuZGJfZmlyZWQsIGZhbHNlKTsNCj4gCWNwdV9pZi0+Z2ljdjVfdnBlLnJl
c2lkZW50ID0gZmFsc2U7DQo+IH0NCj4gDQo+IFdoZW4gdGhlIHRocmVhZCBzY2hlZHVsZXMgYmFj
ayBpbiwga3ZtX3ZjcHVfY2hlY2tfYmxvY2soKSAtPg0KPiBrdm1fdmdpY192Y3B1X3BlbmRpbmdf
aXJxKCkgc2VlcyBkYl9maXJlZCA9PSBmYWxzZSBhbmQgZ29lcyBiYWNrIHRvIHNsZWVwIGluDQo+
IHNjaGVkdWxlKCksIGxvc2luZyB0aGUgd2FrZXVwLg0KPiANCj4gTWFraW5nIHRoZSB2UEUgcmVz
aWRlbnQgb24gc2NoZWR1bGUtaW4gZHVyaW5nIGhhbHQtcG9sbGluZyBhbHNvIGRpc2FybXMgdGhl
DQo+IGhhcmR3YXJlIGRvb3JiZWxsIGZvciB0aGUgcmVzdCBvZiB0aGUgcG9sbCB3aW5kb3csIHNv
IG5ld2x5IHBlbmRpbmcgU1BJcyBhbmQNCj4gTFBJcyBkbyBub3Qgc2V0IGRiX2ZpcmVkLCBhbmQg
YSBzdWJzZXF1ZW50IGt2bV9zY2hlZF9vdXQoKSBzdGlsbCBydW5zIHRoZSBFTDINCj4gcmVzaWRl
bmN5IGh5cGVyY2FsbHMgYW5kIHZnaWNfdjVfc3luY19wcGlfcHJpb3JpdGllcygpIHVuZGVyIHRo
ZSBydW5xdWV1ZQ0KPiBsb2NrLiBSZXR1cm5pbmcgZWFybHkgZnJvbSB2Z2ljX3Y1X2xvYWQoKSB3
aGVuIElOX1dGSSBpcyBzZXQga2VlcHMNCj4gZ2ljdjVfdnBlLnJlc2lkZW50IGZhbHNlIHRocm91
Z2hvdXQga3ZtX3ZjcHVfaGFsdCgpLCBzbyBrdm1fc2NoZWRfb3V0KCkNCj4gcmV0dXJucyBpbW1l
ZGlhdGVseSBpbiB2Z2ljX3Y1X3B1dCgpLg0KQnV0IElJVUMsIHRoZSB3YWtldXAgaXNuJ3QgbG9z
dC4gVGhlIHNlY29uZCBwdXQgcmVxdWVzdHMgdGhlIGRvb3JiZWxsDQphZ2Fpbi4gVGhlIGRvb3Ji
ZWxsIGNhbiBiZSBnZW5lcmF0ZWQgZm9yIGFuIGludGVycnVwdCB0aGF0IGlzIGFscmVhZHkNCnBl
bmRpbmcgd2hlbiB0aGUgdlBFIGJlY29tZXMgbm9uLXJlc2lkZW50LCBub3Qgb25seSBmb3IgYSBu
ZXcgcGVuZGluZw0KaW50ZXJydXB0IChJS1pYQ1kgaW4gSUhJIDExMTcwMSkuIFRoZSBndWVzdCBo
YXNuJ3QgcnVuIGluIGJldHdlZW4sIHNvDQp0aGUgaW50ZXJydXB0IGlzIHN0aWxsIHBlbmRpbmcg
YW5kIHRoZSBwcmlvcml0eSBtYXNrIGhhc24ndCBjaGFuZ2VkLg0KZGJfZmlyZWQgaXMgY2xlYXJl
ZCBiZWZvcmUgcmVxdWVzdGluZyB0aGUgZG9vcmJlbGwgYWdhaW4sIHNvIHRoZSBuZXcNCmRvb3Ji
ZWxsIGlzbid0IG1pc3NlZC4gQW0gSSBtaXNzaW5nIHN0aCBlbHNlPw0KDQpGb3IgdGhlIGhhbHQt
cG9sbGluZyBjYXNlLCBJIGFncmVlIHRoZXJlIGlzIGFuIGlzc3VlLiBBZnRlciBhIHNjaGVkLWlu
LA0Kbm90aGluZyByZXF1ZXN0cyB0aGUgZG9vcmJlbGwgdW50aWwgdGhlIG5leHQgc2NoZWQtb3V0
LiBNYWtpbmcNCnZnaWNfdjVfbG9hZCgpIHJldHVybiBlYXJseSBvbiBJTl9XRkksIGxpa2UgdjQg
ZG9lcywgc2hvdWxkIGZpeCB0aGlzLg0KQnV0IHNpbmNlIHRoaXMgaXMgYW4gb3B0aW1pc2F0aW9u
LCBJIHByZWZlciB0byBsZWF2ZSBpdCBmb3IgYSBmb2xsb3ctdXAsDQp1bmxlc3MgdGhlIG1haW50
YWluZXJzIHdhbnQgaXQgaW4gdGhpcyBwYXRjaC4NCl9fX8KgDQpCZXN0IFJlZ2FyZHMsDQpKaWEg
SGUgKEp1c3RpbikNCg0KDQo=
