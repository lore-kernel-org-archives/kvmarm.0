Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011058.outbound.protection.outlook.com [52.101.65.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C3340A93E;
	Tue,  7 Jul 2026 12:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783427521; cv=fail; b=JRq4x+8QS8L4NPQzZ2njONoGnqepwL8Fr7YbUm8X3t/lOyO9x4A0OqkHzgtRcfU6dEboshw8hhTh9ZMhg1a2AfdIF9xfAiEKAimamDmrfjiseWPcVSEG8o1OX64i1k9KQfFYd25LWf/yh3v9aUqg8sOP/aDTgh6H6vrMOqFiH/w=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783427521; c=relaxed/simple;
	bh=q/yO+830cn5+me/uxQ2lQEe4LI+gRBifUdC0OVE3pTE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZpP8yvToOGFPXsGIeitQ8aWGxSdRBaQ0KxNcvn36u2EMW3VUQE9SCDQxz/w1gIWLzMfpb5/j/ULguW38PmyvMdUgO7+PoGAnyGkRLxwqD5jLZJnXuKFeA5vwLpRY1rJvlmwfUUPUVg8xQsEbxM2NURhTTFnAE9bmt3gas+biPzQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZAARW3iK; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZAARW3iK; arc=fail smtp.client-ip=52.101.65.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZAARW3iK";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZAARW3iK"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=AZHMxDpJ4QeP7cuABFoauwrCNcesRh1/RHxqXWeq5uMROFl8lGXDGTzdnHH7KKVnBSr73wySNSkqddlMJTSs2aQqh+HDnzPPdEpEN5T6H3yaKA27Ogg12nRlwlS+YG2VR9mQQYSqSsQZE4el/ScITrEiC2Ho3anArco5oVCe+g77q/aMG0V6IntoBLKkps/kEREyw0yWARIqufuUHGBb7eTpRsBdBxt8egFxxXCrIpkEm30fIhcs4COz0gTpHgXAQ/ncdJBw33L6gmq01USI8SdIND1VUJqh9rHTzrhRD5BxdRoPaRB64r6wIbB8tVD1wv+sxkwKK4Muz3ULYWnWcQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q/yO+830cn5+me/uxQ2lQEe4LI+gRBifUdC0OVE3pTE=;
 b=ofQdeI7hVqCj2fcSUqxtRAixv1PzWaXv1NOKXBhgi1ijuTbyba/kz15HLmnOelAt3DLxs3g7gf8R4qk2qxBvQs9IwMl2YaPI25nt1vaBGeu6E5I625kaC78bS50VwxiDum+q2TUVmDtsD8tYhr5EAzW+fvFTbIPMOBSX4H1rLxt8/zfVagez353HYH4NEWK6+VaPIAaBkqiEVlQX7gzPtE61Ehi1/soZaYnPbGFMoMs9HHBpID2WPkVp0BwdOtFIo27K4Pjfh+KK4aRpB8RTE0AmSokC8egFBJ83SOtead8T+NSCXeR9bKeA3VcBTlC6uYTklWb/IeSrdApva+a8ag==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q/yO+830cn5+me/uxQ2lQEe4LI+gRBifUdC0OVE3pTE=;
 b=ZAARW3iKKJrSTJmD0G6T0x+nwYQTDGUuedzVIMh1xtsiw+bGA5KyzpfRCfYx/z9MpVcJfbZINEi+z9RgSn2u7OLN6DQ4NSx3WsU/1mIeL8NNOcAMl/dvqu8XOtAskBZyF7g0KjeWkXxo6VzaF1WN217N4bJmShGufOomVGeKP7w=
Received: from DUZPR01CA0149.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bd::25) by DBBPR08MB10589.eurprd08.prod.outlook.com
 (2603:10a6:10:538::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Tue, 7 Jul
 2026 12:31:52 +0000
Received: from DU2PEPF00028D03.eurprd03.prod.outlook.com
 (2603:10a6:10:4bd:cafe::8d) by DUZPR01CA0149.outlook.office365.com
 (2603:10a6:10:4bd::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.13 via Frontend Transport; Tue, 7
 Jul 2026 12:31:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D03.mail.protection.outlook.com (10.167.242.187) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Tue, 7 Jul 2026 12:31:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OdS9XAg9i46jP0+lW0NlJL6Ux409CqTa2Iq3shFwt5xCCPOm7YVRD6e1r+3igZA0CMvqUKuJJONx9PlMOI1coNxs1PfwmhZfwCIUWAEH7FjGZt68V0arK6oY7WEahdxKZftKfhb99Zkm9duHnOgHFiZTU1vqVuv4kdn75NH7O81OTKeZraXV7UayqTK6bPwD86nFCV/5uxOz+zheHcsrNYIe14sXQ0LThixPMz01RnQZSf4yf2+di4VrMVAuZZnY+1tq0u8ic2P7YUHGNzCFA8jG8W2QXInAGDHUrX9K8HeVl+jFxLY/g5bahPBFOEmW5GlKxnZeq2zJbal7/kcC7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q/yO+830cn5+me/uxQ2lQEe4LI+gRBifUdC0OVE3pTE=;
 b=sErCF51DflfxeN+UGRmYV1akwcTZg3sVThAYEkhbELmGobclg2DGJIEkPzMEwU9c29QgqOIqaLRzGw1Z07Vd3oOtpx8GmLZ86/6AhwUa1JO8G9p5YPi3K/nNHBKxCpLO4RK71YBnA26BbOOIqvnXdBZs/oXKZKzF+5YTJIDnzhd2DvnB1WbOqj/K756gG6Gn4vsf43nlvjI5vqUjZJK+0ZSK1ft52qqnI/BSBIjzFc2ys2YC1NpwxyqVfRMlyWLofLpy5H4tnI12Z8HITHqO2ZZJL1Qowj1UhTE5nP1YQX2GP+P3wZKI43+SlRmcv3b0c6GaCZNv1O/Ka6MNhPzSVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q/yO+830cn5+me/uxQ2lQEe4LI+gRBifUdC0OVE3pTE=;
 b=ZAARW3iKKJrSTJmD0G6T0x+nwYQTDGUuedzVIMh1xtsiw+bGA5KyzpfRCfYx/z9MpVcJfbZINEi+z9RgSn2u7OLN6DQ4NSx3WsU/1mIeL8NNOcAMl/dvqu8XOtAskBZyF7g0KjeWkXxo6VzaF1WN217N4bJmShGufOomVGeKP7w=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV2PR08MB11943.eurprd08.prod.outlook.com (2603:10a6:150:343::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Tue, 7 Jul
 2026 12:30:47 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0181.009; Tue, 7 Jul 2026
 12:30:46 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 01/40] irqchip/gic-v5: Allow KVM setup without a
 maintenance IRQ
Thread-Topic: [PATCH v3 01/40] irqchip/gic-v5: Allow KVM setup without a
 maintenance IRQ
Thread-Index: AQHdCwPAaXwuP3H1AUGZkiZkxLYj6LZb/TMAgAYFoQA=
Date: Tue, 7 Jul 2026 12:30:46 +0000
Message-ID: <026319388dc0a0e0680d58465aece249ddba43a9.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-2-sascha.bischoff@arm.com>
	 <20260703163303.669601F00A3A@smtp.kernel.org>
In-Reply-To: <20260703163303.669601F00A3A@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|GV2PR08MB11943:EE_|DU2PEPF00028D03:EE_|DBBPR08MB10589:EE_
X-MS-Office365-Filtering-Correlation-Id: 079b3ee0-588c-46f4-3e3d-08dedc23b91f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|38070700021|18002099003|22082099003|3023799007|56012099006|4143699003|11063799006|5023799004|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 sZom6W20s3Xv3yRyVPk9f64LqGZS7SyEcC5gx306F1MGI797gpdIK0axAAEozvousOhUrwcYMmlxQbcGPdYXwz0d6wvXlh5XplwQmTmX/a2euRPGsGonZ3z5+GTZSG5vzHh92Tq6060DLb6/ckyRUTPL+TyF4JfrfmKCYOkJD1g7vuP1gVA5GTM62yrn18R6nL7apGPSC6yxhpsKZW/pF5qPFJQkxcGTjH7qYTEi23WJeD0lKqlaslBClStGqoDD00AZ/kQbyBl4T9jmJ9eJ6YPiUZDl/FK7rcEH1h1psghJPn9i3srnq07+ftJ0BMXvtlqF9nFYhaLHOEcZwFIqkn1q6737T2h65uL3mFuH5TM/1EWq4fyw/TpEk3/9iilQj8JM0pDsSPNKAepwa8qehRATkjtgPY6Nw3t155Xl8ths9f2FldblbH/ZPfQ+tBeyBafoLGmOWykIL44LGaAvI1GtJdSLrERRouzqhDtcrCDE/BeVpzN2vRxYjYxjfzDM/pk+94u6W/YUfo26nx0dNebJS5gAx7ih0eeaAs732amgPfvWXn43klenFGry3HO1S/PdpYjPs5XyWu6LGBAaLEGD9Jj+IUbCwbiHZOLBHFBD9KrVOzg8+ExPu8quZqZ1pNzNMRuF71Jf0MN5c18gZi59eoa0BkLCSLbmAZF5A3Ixv3FTH9EfWTEZSEjWoebgtxgw/UJtrH3rGqjWA7gpC1VylsZ7cAwCuCvo1yZ1f1k=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(38070700021)(18002099003)(22082099003)(3023799007)(56012099006)(4143699003)(11063799006)(5023799004)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <50592112BE98CA42A3F008EC8E39D7AE@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 KA6/KL43NL5mWdMDp5wS6EKnVYQOYNHyfbujSEnGLsay5Ax05+adAaAMlCEZ31KAAL7SBSovvgdzi63bRT2z4dYbMj25HtToeNjHt7SpiBm3zgFX34gW2NdgXwZti6DyqNuGux89oYBSz+lOLIHLwRscFWxhCY3oJUTNBFFHoQP4ddAIi/TvK8ym1v2ZBxxDc867AoTRmj4YjIiEHwCkcyox4WztTmlsH/CxJF3hhL0GwYPdfXJHl4jTE7/0w40CPFoqrEO3ZPz1SqvsW7BXwMK3PXEfvd4MaFHhS3YkNcwXHK0+bSNQL0ly7iAm8fYNW2sZ9i4+CoAXHtYGF2TzKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11943
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D03.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b6c6c214-5358-463a-80a8-08dedc239209
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|14060799003|36860700016|1800799024|82310400026|35042699022|6133799003|56012099006|5023799004|4143699003|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	SD9WsFbJR/RyULIj9/5iemEzILJnTDZb1SYfv+yJ5uFgO9zJRFpe/c8UzmLKcA1WVY9zP9Z7/dmNuSTWzY2H2tuqS1R487m+6VdtMrCwOa656yNEw7oyjbmDkcuTHJMcqdGqUdpTJ/FqgTrBHoVQZ95dHpBW/w1Kd927nvpLDYta+60stW0zi9AiG/PfymBXLCNlt+f79/ax9m9oEIPCodJSaJftEKlYEsU2QIsUnJzjgvDcLD9PNF8TRy2216606vK3vRbKkqFLsZI9f8vr3zXk9M371InR4yA7wXkPJwvdd3wq5rxht38TXsIWNqK9OxZFWIwj4kt/Z2aKH0WkZEXZHujkZT+uraocOL01N8DUQg0NhCDnRNxEjTRiWYe9RLNCUJfW/pvsOKTjTeU1NhrG4rNGdyRL3JkW3rT3nXxC110gIqXaEoUPtIbxEszpE1/iA4cyxgDpwZf3t20LDZKDWFX8IJKXLFPR+oyHdB7mUR6TI+F8YdnV/RmTK5hgDx5UlGGDH7ybWFemHrlYZ7OU4UoVOfsl4OT4NCKOcLQ7IitVIJFy2RrBxiqkIFrF0IVones5511bS/fh3cpmYNzIPN7vLDp6zF8nt27kKNbOrl34AnXniI8g2bBC/x6DO0gJaUt25CITSj9gpcGJmD76QPPwlpFC9Ss37SBv5+H+XUFQN1bC4Owm1AeE98nerjIiO8jZTPaHYVeig0DeSw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(14060799003)(36860700016)(1800799024)(82310400026)(35042699022)(6133799003)(56012099006)(5023799004)(4143699003)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Xj7Ow2/BqdulXTQN2Ons+UciGfJJdvU8pzSMe3fZyxCmE5dtCO6XwRrOXgaKdmh3ZnY9Hx/FSF2tUmxbDHqoPi/7NZ5kFrCX8DpxQx2Z45XZ9EBqBF3D8Zq/fPfQlMswFJCG3P0YE+xiYTyU3mTpHKwGVV4Ce0l/3G3EzP2HYhOtSJVBlyiSuCiVhze5vV8LYmmWe7fvW/05b7dQ9zYLD4i6sdMWzTpwEmr53ht2rIiXVYAC9fAi+muzXEfCYW7yDSZHQ/nb0fBHz+IsQ5OCVPFIKNlnvCY8LQ2xwmQ09JYTa1USYPg9UxscHJ4rW2KhyMBb6Nl7VNU/ni88M0ZSteEh2QFLytHoTVG1lqehP94g8bT9V7yF7teevZvK3DsZs1mIBo3clJXE67qyghqg+yEMnne2yEkhjAL7ReCBux6W36SSXTS2Ml1/nN9Q/IK+
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 12:31:51.9868
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 079b3ee0-588c-46f4-3e3d-08dedc23b91f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D03.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10589

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjMzICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gDQo+IE5l
dyBpc3N1ZXM6DQo+IC0gW01lZGl1bV0gTGVha2VkIEtWTSBgZ2ljX2t2bV9pbmZvYCBhbGxvY2F0
aW9uIG9uIGVycm9yIHBhdGggd2hlbg0KPiBHSUN2NSBsZWdhY3kgaXMgc3VwcG9ydGVkIGJ1dCBt
YWludGVuYW5jZSBJUlEgaXMgYWJzZW50Lg0KPiANCj4gUHJlLWV4aXN0aW5nIGlzc3VlczoNCj4g
LSBbSGlnaF0gV3JpdGVzIHRvIEdJQ3Y1IGNvbnRyb2wtcGxhbmUgc3lzdGVtIHJlZ2lzdGVycyAo
SUNDXypfRUwxKQ0KPiBsYWNrIGltbWVkaWF0ZSBgaXNiKClgIHN5bmNocm9uaXphdGlvbi4NCj4g
LS0NCj4gDQo+IGNvbW1pdCA3NzUwMGY3ZGFjYmU4YzZhYzE1MjhiYzU5NGQ4MTBiZjk1Y2VmNTYz
DQo+IEF1dGhvcjogU2FzY2hhIEJpc2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4NCj4g
U3ViamVjdDogaXJxY2hpcC9naWMtdjU6IEFsbG93IEtWTSBzZXR1cCB3aXRob3V0IGEgbWFpbnRl
bmFuY2UgSVJRDQo+IA0KPiBUaGlzIGNvbW1pdCBtb2RpZmllcyB0aGUgR0lDdjUgZHJpdmVyIHRv
IGFsbG93IEtWTSBzZXR1cCBldmVuIGlmIHRoZQ0KPiBtYWludGVuYW5jZSBpbnRlcnJ1cHQgaXMg
YWJzZW50LCBwcm92aWRlZCB0aGF0IGxlZ2FjeSBHSUN2MyBzdXBwb3J0DQo+IGlzDQo+IG5vdCBy
ZXF1aXJlZC4gSXQgc2V0cyBhIGZsYWcgdG8gaW5mb3JtIEtWTSB0aGF0IHRoZSBtYWludGVuYW5j
ZQ0KPiBpbnRlcnJ1cHQNCj4gaXMgbm90IG5lZWRlZCBmb3IgbmF0aXZlIEdJQ3Y1IG9wZXJhdGlv
bi4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXY1LmMgYi9k
cml2ZXJzL2lycWNoaXAvaXJxLQ0KPiA+IGdpYy12NS5jDQo+ID4gaW5kZXggZTlkMTc5NTIzNWE2
Ni4uYzA0NTIzYTQzOGNlZSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdp
Yy12NS5jDQo+ID4gKysrIGIvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjUuYw0KPiA+IEBAIC0x
MTQzLDEwICsxMTQzLDE4IEBAIHN0YXRpYyB2b2lkIF9faW5pdA0KPiA+IGdpY19vZl9zZXR1cF9r
dm1faW5mbyhzdHJ1Y3QgZGV2aWNlX25vZGUgKm5vZGUpDQo+ID4gwqAJLyogR0lDIFZpcnR1YWwg
Q1BVIGludGVyZmFjZSBtYWludGVuYW5jZSBpbnRlcnJ1cHQgKi8NCj4gPiDCoAlnaWNfdjVfa3Zt
X2luZm8ubm9fbWFpbnRfaXJxX21hc2sgPSBmYWxzZTsNCj4gPiDCoAlnaWNfdjVfa3ZtX2luZm8u
bWFpbnRfaXJxID0gaXJxX29mX3BhcnNlX2FuZF9tYXAobm9kZSwgMCk7DQo+ID4gLQlpZiAoIWdp
Y192NV9rdm1faW5mby5tYWludF9pcnEpIHsNCj4gPiAtCQlwcl93YXJuKCJjYW5ub3QgZmluZCBH
SUN2NSB2aXJ0dWFsIENQVSBpbnRlcmZhY2UNCj4gPiBtYWludGVuYW5jZSBpbnRlcnJ1cHRcbiIp
Ow0KPiA+IC0JCXJldHVybjsNCj4gPiAtCX0NCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogV2Ug
cmVxdWlyZSBhbiBNSSBpZiB3ZSBoYXZlIGxlZ2FjeSBzdXBwb3J0LCBidXQgZG9uJ3QsDQo+ID4g
b3RoZXJ3aXNlLg0KPiA+ICsJICogR2l2ZW4gdGhhdCB0aGVyZSdzIGFuIGV4aXN0aW5nIGZsYWcg
dG8gY29udmV5IHRoYXQgYW4NCj4gPiBNSSBpc24ndA0KPiA+ICsJICogbmVlZGVkLCB3ZSAoYWIp
dXNlIGl0IHRvIHRlbGwgS1ZNIHRoYXQgdGhlIE1JIGlzbid0DQo+ID4gbmVlZGVkIGlmIHdlDQo+
ID4gKwkgKiBkb24ndCBzdXBwb3J0IGxlZ2FjeS4NCj4gPiArCSAqDQo+ID4gKwkgKiBUaGUgY2hl
Y2sgZm9yIEFSTTY0X0hBU19HSUNWNV9MRUdBQ1kgZXhwbGljaXRseSBkb2Vzbid0DQo+ID4gdXNl
DQo+ID4gKwkgKiBjcHVzX2hhdmVfZmluYWxfY2FwKCkgaGVyZSBhcyB3ZSBydW4gdG9vIGVhcmx5
Lg0KPiA+ICsJICovDQo+ID4gKwlpZiAoIWNwdXNfaGF2ZV9jYXAoQVJNNjRfSEFTX0dJQ1Y1X0xF
R0FDWSkgJiYNCj4gPiAhZ2ljX3Y1X2t2bV9pbmZvLm1haW50X2lycSkNCj4gPiArCQlnaWNfdjVf
a3ZtX2luZm8ubm9fbWFpbnRfaXJxX21hc2sgPSB0cnVlOw0KPiA+IMKgDQo+ID4gwqAJdmdpY19z
ZXRfa3ZtX2luZm8oJmdpY192NV9rdm1faW5mbyk7DQo+IA0KPiBbU2V2ZXJpdHk6IE1lZGl1bV0N
Cj4gRG9lcyB0aGlzIGludHJvZHVjZSBhIG1lbW9yeSBsZWFrIG9mIHRoZSBnaWNfa3ZtX2luZm8g
YWxsb2NhdGlvbj8NCj4gDQo+IElmIEFSTTY0X0hBU19HSUNWNV9MRUdBQ1kgaXMgc3VwcG9ydGVk
IGFuZCBtYWludF9pcnEgaXMgMCwgdGhpcw0KPiBieXBhc3Nlcw0KPiB0aGUgZWFybHkgcmV0dXJu
IGFuZCBwcm9jZWVkcyB0byB2Z2ljX3NldF9rdm1faW5mbygpLCB3aGljaA0KPiBkeW5hbWljYWxs
eQ0KPiBhbGxvY2F0ZXMgZ2ljX2t2bV9pbmZvLg0KPiANCj4gTGF0ZXIsIGt2bV92Z2ljX2h5cF9p
bml0KCkgcHJvY2Vzc2VzIHRoaXMgY29uZmlndXJhdGlvbjoNCj4gDQo+IGFyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy1pbml0LmM6a3ZtX3ZnaWNfaHlwX2luaXQoKSB7DQo+IMKgwqDCoCAuLi4NCj4g
CWlmIChoYXNfbWFzayAmJiAhZ2ljX2t2bV9pbmZvLT5tYWludF9pcnEpIHsNCj4gCQlrdm1fZXJy
KCJObyB2Z2ljIG1haW50ZW5hbmNlIGlycVxuIik7DQo+IAkJcmV0dXJuIC1FTlhJTzsNCj4gCX0N
Cj4gwqDCoMKgIC4uLg0KPiB9DQo+IA0KPiBXaWxsIHRoaXMgZWFybHkgcmV0dXJuIGJ5cGFzcyB0
aGUga2ZyZWUoZ2ljX2t2bV9pbmZvKSBhdCB0aGUgZW5kIG9mDQo+IHRoZQ0KPiBmdW5jdGlvbiBh
bmQgbGVhayB0aGUgbWVtb3J5Pw0KDQpUaGlzIHdpbGwgaW5kZWVkIGJ5cGFzcyB0aGF0IGZyZWUs
IGJ1dCBkb2VzIHNvIGluIGp1c3QgdGhlIHNhbWUgd2FzIGFzDQphbiBleGlzdGluZyBHSUN2MyBz
eXN0ZW0gd291bGQuIFdlJ3JlIGp1c3QgcHJlc2VydmluZyB0aGUgc2FtZQ0KYmVoYXZpb3VyIGZv
ciBhIEdJQ3Y1IHN5c3RlbSB0aGF0IHN1cHBvcnRzIEdJQ3YzIFZNcyBpZiBubyBNSSBpcw0KcHJv
dmlkZWQuDQoNClRoaXMgaXMgbm90IGEgYnVnIHdpdGggdGhlIHVuZGVyLXJldmlldyBwYXRjaCwg
YnV0IGl0IGlzIHNvbWV0aGluZyB0aGF0DQptaWdodCBiZSB3b3J0aCBjbGVhbmluZyB1cCBpbiB0
aGUgZnV0dXJlLiBJJ2xsIGNvbnNpZGVyIGl0IGZvciBhbg0KdXBjb21pbmcgZml4ZXMgc2VyaWVz
Lg0KDQo+IA0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBUaGlzIGlzIGEgcHJlLWV4aXN0aW5n
IGlzc3VlLCBidXQgZG8gdGhlIHdyaXRlcyB0byBHSUN2NSBjb250cm9sLQ0KPiBwbGFuZSBzeXN0
ZW0NCj4gcmVnaXN0ZXJzIGxhY2sgaW1tZWRpYXRlIGlzYigpIHN5bmNocm9uaXphdGlvbj8NCj4g
DQo+IEZvciBleGFtcGxlLCBpbiBkcml2ZXJzL2lycWNoaXAvaXJxLWdpYy0NCj4gdjUuYzpnaWN2
NV9jcHVfZGlzYWJsZV9pbnRlcnJ1cHRzKCk6DQo+IA0KPiAJY3IwID0gRklFTERfUFJFUChJQ0Nf
Q1IwX0VMMV9FTiwgMCk7DQo+IAl3cml0ZV9zeXNyZWdfcyhjcjAsIFNZU19JQ0NfQ1IwX0VMMSk7
DQo+IA0KPiBBbmQgaW4gZ2ljdjVfY3B1X2VuYWJsZV9pbnRlcnJ1cHRzKCk6DQo+IA0KPiAJd3Jp
dGVfc3lzcmVnX3MoMCwgU1lTX0lDQ19QUElfRU5BQkxFUjBfRUwxKTsNCj4gCXdyaXRlX3N5c3Jl
Z19zKDAsIFNZU19JQ0NfUFBJX0VOQUJMRVIxX0VMMSk7DQo+IA0KPiAJZ2ljdjVfcHBpX3ByaW9y
aXR5X2luaXQoKTsNCj4gDQo+IEFSTTY0IGFyY2hpdGVjdHVyYWwgaW52YXJpYW50cyByZXF1aXJl
IHdyaXRlcyB0byBjb250cm9sLXBsYW5lIHN5c3RlbQ0KPiByZWdpc3RlcnMgdG8gYmUgZm9sbG93
ZWQgaW1tZWRpYXRlbHkgYnkgYW4gaXNiKCkgYXMgdGhlIHZlcnkgbmV4dA0KPiBpbnN0cnVjdGlv
bi4gTWlzc2luZyB0aGlzIGNhbiBjYXVzZSB0aGUgQ1BVIHRvIG9wZXJhdGUgdW5kZXIgYSBzdGFs
ZQ0KPiBjb25maWd1cmF0aW9uIGZvciBzZXZlcmFsIGN5Y2xlcy4NCg0KVGhlc2UgYXJlIGZpbmUu
IFRoZSBJU0IgaXMgb25seSByZXF1aXJlZCBpZiBvbmUgbmVlZHMgdG8gZXhwbGljaXRseQ0KZW5z
dXJlIHRoYXQgdGhlIGVmZmVjdHMgaGF2ZSBjb21wbGV0ZWQuIEhvd2V2ZXIsIHRoZSBjYXNlcyB5
b3UgYXJlDQpoaWdobGlnaHRpbmcgYXJlIHJlbGF0ZWQgdG8gaW5pdGlhbCBpbnRlcnJ1cHQgc2V0
dXAgYW5kIGVuYWJsaW5nIG9mDQppbnRlcnJ1cHQgZGVsaXZlcnkuIFRoZXJlIGlzIG5vIG5lZWQg
Zm9yIGFkZGl0aW9uYWwgc3luY2hyb25pc2F0aW9uDQpoZXJlIC0gdGhlIGludGVycnVwdHMsIGlm
IHRoZXJlIGFyZSBhbnkgdGhhdCBjYW4gc2lnbmFsLCB3aWxsIGJlDQpkZWxpdmVyZWQgZXZlbnR1
YWxseSBhbmQgdGhlIElTQiBnaXZlcyB1cyBub3RoaW5nIG1lYW5pbmdmdWwuDQoNClRoYW5rcywN
ClNhc2NoYQ0K
