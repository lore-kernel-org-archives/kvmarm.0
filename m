Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013042.outbound.protection.outlook.com [52.101.72.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB18224234
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.42
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306927; cv=fail; b=p500wmSNn48UwlrUCqcj9PzhT9m6y7nE/FtNiRsWPPYvr5CW0UvwryJSoVQHdE1/jLNp+iAHhUDdj1ZG1OEjJw6xxPfsoqrrUFaYVQDfqhErEKa8gApGVSJGe8P7vmzjkoWaJbu50pTcZspY8DFQHynGCOQDhUVIJ5lDWvZbHGo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306927; c=relaxed/simple;
	bh=6AD7RMVQOmeBPKNhcVom/iQNExiHhxHEvkY3o+NNCFw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kTXAhNChqKbGf+zFA1bYgL9sElXpgqrG7feWTO1RwwHucVZC5lljrP4XMgj2wDfqWmNz8RmYIL8gZbpxlW5tBYm6Qvymbgxjwy/1I+Rq3cSbRNTMP0eT9mn8h86boinrpBEOPiraVjfzgr1PfC5MfTcUgvyJCF3UIHTG/HAq7ZI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EhJih4Q0; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EhJih4Q0; arc=fail smtp.client-ip=52.101.72.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EhJih4Q0";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EhJih4Q0"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Mv+h+C4ElJ/HT4ryrD5UncnD9PpDQ6NJORWJL95kn2949ikA3U9nUpY7mUlwhsagIGx2kxbmNB7DG6o6YdxI11KJOZvt2Nx7JDA2Fd48+nC1k5r5z36JSQBnMLlpBUNo2pbeQTESP8TF9mNXKh6b+y6EoYmELfo+ZInidpd+g5x0HFZ1MR7BsssJBDpKjtY/70CqO2T2Id5IGxT83Tgj8OGA/+B3+6UbOd0YaVEJa5OVk8ghu51z9GQkQEvuLB+B8GGffIZvLf6n0NOFZb8GqEta2wSExQrSK2mqWEpyJ6ijUx2TNDejQlzLj+vjjzjfcfxc6iZMAk4b/IPFaR6M0A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oiiwgdFJca0vheW0JU4Y8tYylHVbyRZgQ8uSsAadArk=;
 b=Ak2sE0Lh0oucD7ow/jGh1bDxXYUVKrw6G55j4NtxWUqJx/MbvujvhTiaIadKKk6VFNY4Hhh/ZbZJFTeHXkzoohmMrGz2NEn7ca4cjWIQ/lenXna+g7cXQ4InPJR4u3ujy11gVXp57RZGoiUx7tkpNXO4kbdFm4XNPcVSP9D3mqy1tZAne+yrCHtp8R+3rIf6giR5M9Ij3KLq2WANH2Y+UGDuR3cGae6do+uX8G5k5zLCJtZbGTgDE+BWF/xljEuUo/C/cEflYQ0VxECMVkK2vdhMRh6Sz4vBwTBl4BzzroKQdjD+0im2pEWVAqm0lbQo1XPpk+8Hy1vb3DjdZst9sw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oiiwgdFJca0vheW0JU4Y8tYylHVbyRZgQ8uSsAadArk=;
 b=EhJih4Q0Z71Z3gM21wGIsTSF1ovBvoYVJaUIWYWQZQmmTELclyrguu6iyGApsm67J9fA9uue/IVMAti7bL7rrx2+mNb3y69tTLh+oQWYSEXKdJS4Z7yKjCrPLEkCWUL5Vxel9hbfle3ofXNqeVAZfBmKtpfMonsXGxTPCFQ3DfQ=
Received: from AS4P189CA0061.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:659::10)
 by AM7PR08MB5367.eurprd08.prod.outlook.com (2603:10a6:20b:dd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:22:01 +0000
Received: from AMS1EPF00000048.eurprd04.prod.outlook.com
 (2603:10a6:20b:659:cafe::f7) by AS4P189CA0061.outlook.office365.com
 (2603:10a6:20b:659::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:22:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000048.mail.protection.outlook.com (10.167.16.132) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:22:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZxwwuLj5l+/AFfZWuMc8BdOabFnKW0FZiTMR7arrEU/A9Gi/h5LtKjn9QKdtHjCPfCRHADvwIoYvI52kcdBw4C9/rq/BQM99XWDNu7uFtkgJoZLLxpTwTK0uagxvNjn1Mr74oNLTjStNXSVM2GK8LDfijgBMToIVuJiwhpT9HABGCJO+v2pPoSB3ptShcLq2tCHie9smUZH7v5CFfs5039YyKhg5xgiVXwmxebQxa1cUxS+mxbcscLSG3XfTJ1fwyLvfePHsViGawY/GmUfk3G3OsF51o/RQbWGzo19lKQUQmmWOvU2veJaMqbPFdQp9krehiCg8+uSH6bgzhOCBEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oiiwgdFJca0vheW0JU4Y8tYylHVbyRZgQ8uSsAadArk=;
 b=U2PwBn/NcRIH+EDcD0ZLhV4fjCp3oTOvskODMAIcSRvgPnMdZY2CnvOsmYRGuXeqJtWJvxJbfcpMnLzaUI7E+3qAKhcwya5nyH+gl4LO1+A++C5Mmsl0jGPbtgU6HOhKugdkGZX95lcWVU4z6is9ZSTEasdaLs9IHRgys5wh53rDJ1qGvgeCA6VDd4BjHmOhHh9ggLstEadEriCe80HcBLvmYwnK8gNx++bKZfosrrwgMvMo39Jh+++3Bnfb9Ta6u90/qQ/5U5Z0B0+Qh2HAZJ+vRphfFl0Kki1awa4ND7BtVROXHB5v1fEe9djArDV10VDEmyDAHYYFH+115ojJew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oiiwgdFJca0vheW0JU4Y8tYylHVbyRZgQ8uSsAadArk=;
 b=EhJih4Q0Z71Z3gM21wGIsTSF1ovBvoYVJaUIWYWQZQmmTELclyrguu6iyGApsm67J9fA9uue/IVMAti7bL7rrx2+mNb3y69tTLh+oQWYSEXKdJS4Z7yKjCrPLEkCWUL5Vxel9hbfle3ofXNqeVAZfBmKtpfMonsXGxTPCFQ3DfQ=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by DB8PR08MB5307.eurprd08.prod.outlook.com (2603:10a6:10:114::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:20:57 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:20:57 +0000
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
Subject: [PATCH 43/43] Documentation: KVM: Add the VGICv5 IRS save/restore
 sequences
Thread-Topic: [PATCH 43/43] Documentation: KVM: Add the VGICv5 IRS
 save/restore sequences
Thread-Index: AQHc1mHUlrXAl3FD4UikYuQ8zmH3Fw==
Date: Mon, 27 Apr 2026 16:20:57 +0000
Message-ID: <20260427160547.3129448-44-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|DB8PR08MB5307:EE_|AMS1EPF00000048:EE_|AM7PR08MB5367:EE_
X-MS-Office365-Filtering-Correlation-Id: 9563d07b-b234-40ef-cd41-08dea4791c90
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 Qj+jYFRIidU85fOy3bIbvDZZj5CWU2FL91QzBzD3xxQnfOEYJsMAnQfgsy+tSU0Sy+CMiJYNbkjetF5dpydqmykWPMn4Kowa2AndZ3k5HO9seJJfQfKIo1bQol8MSMynesu9VQXjGq77VU/OlYaxK+2rXlwCOFFPfA0hJoU1ij3N3nmhhLkzV5e0WSU5slVMgFBmVeo9t/Q6WWK9jVDUd4ZEPzvPACKIrjEDHJIGvjuD2YkNiKZ6+xepaKb0ozoBLDUmVooH9hKIKdvtr2FHnSKvVhmkWbZb1eAnrdJGdehhCx5c39eP60RvqslqQK00vtN0BjXlz1F63VsoiEs1YpCcv2RXJTbnLbNnOPvhTJ7hOWrry+uGW+i+mTm2QHNZKgnVpb8lLmivN2mWPslSzb0xQUwt91x8tHteKa3HevTGJLbnq7Z5gmLM8hhBrvT3O0s/EIaV6YZznM+ILn67bGe+IhO4bDkFaCXApBJPO+bTc8FJkip/a0Q/5NB5IWXtRwmEXexP7ZaLhLvpmj9CW/LYfCN1/tH2Dp0BionmlVvZfg9QDYY6gW4JiiBLjC1gS+8/ERx8UNmw6SG9eQi74Mu43U373TVsbpyFssFsHrpbp4rKSUVHBixYCcfi3vNO5PemszGBonYEOqlb86kgX2tzgL3kCg0k39VUQLqLQoit+3kftN+FcbEegXIzPV94DnBHFcsva2Qo8urw1PLHNkHy90OvmXB4Rmh44OkIrJFpTpVbNEiaKARSVfxb/wzkGoKVYO8Bi3+j/jVyrzUPRoRzauN4DGsQNRZkJdqeBhA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 NoAKNWkAB7oBMyh0jhdSr46HQJ3HHK8S95tT3HTDB1mD5ZMvLaqxQ524xOzNecWz092n7CvMYNA0wniHWorTMWDj+bb13/9K651TZTtE+KtEtW9cTsZ/g39hxmspjGSdf7u+4OJTsHIvVuJgTX6xf/iufM52/H11TTuyN3i3DRYB+divNprPHjIlXcQeQEleIhW9aSaxZBgpGwlQy1PVYK7AhEaBqUcIOwEDbHNFWn5As1HacNRjmo+8fpUTRUxheddLqNSQ7/6tB65R6+uS6TbYEax2DB1pvubiGddyEC6W37nCQgG+UbIzk4/JHRcS7AGplLjJYrm2LSL/2GBDuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5307
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000048.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1060889b-ac0c-4ac8-5a40-08dea478f6db
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|35042699022|82310400026|1800799024|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	VXeeunYbzLst3s80O9tUc+YJcI1Fq/osBfMxeHklBo6alB08mGV2hng5iEV/t2we3oNdZ6B74bVqpSqAcIOcaRCSY3MwS5F/R1895jk2LUOP35pc9CA0J3wv4N/iPVHJB4Wp+CFayeVdawfx+DSP7WK0Jvew+moaaHK4XCe5h85mwjCm2zzPEhT5/q+xFxzBzlHEgbHQ62SHDlatFyEOFIJtGpwtVSZhCfFxcwyjZH8UX20QTL/f2VeZTvr0KKCeqtfxTCgwQbn7/Ps4OMHNj9Y1yxQzmyOap9LccWJtDfPgiywnhnnsqsPTVotbueNYSPuM1XMwaTJsyVk/e8j2LvKnCYlXbGDzkPlHAHLpNSMJiCerLi9uSs+tPTDnudEw94W2YDWb1GIRxlMOSbU4JktznXLB6YUBF7ypBMkWLLNlVTGMn6UGAykRJD2etKJ9cYo25FYPUBpcL2Bn840WGg2/wf7Od5j7zH9eaLk8aqnSqbnfuIWOl3NttgFc8WUqwAor8bW5fafs6rH5toqKuZWd52CKcjrKb8aT7Crv+pwzUte0yU5km7zRybqEyR/T1INfzPYcpCk8+VoEcbSJmtNAX6OK0fm9hjfAAYj8hvAdjR633gKTd8WXCKZXOMWn9Cql6yQWmVor3hwccoWAtnzrnmPjo2efAuBhVisS5LruLrhQkV46gDaqPquHSt+27+pw8bLYPUJHyrLY+i2XyV2RlW/NZxKavD6oqSzvaaf1OxCRL6P+Ydv6myhK0DnFRu6AuyofSnUFWMpnjr0A9Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(35042699022)(82310400026)(1800799024)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rod8i6sqlgN3MOGNifMxajfpyQfGPfI2+qUpSqZ/FB4LWc1CRUzFvKXNzvbBYTK//3eMlfdbUouIT5bl09RR35EUC94rNHO+Sy1OVZftsVpWws0IrU5QRfVCDALQumq6URaqoCf2/YGIn/9pMssEiy67Kqk19kQEfsOgNBh75WAbXMpL9mXUVS1B9m/DKfGqCHohMB5qeThlGGWTeQ7lTFJtnLJ0DvXsfh8rZqvv9OLCGI6Zom1EcJbwV6hcbOVvgT4agZPGbl08Fs4uGur5XUKvZWuIU2KpClP8dKIrWQ75C86ctb2+ei/vNcZaqaIkDbDRQS7HTYiNX0pOkddhTXltQIddxhyTJQJreXjJL0lPyXYZK1hbTbJ0zGB+5syx4+g0BkQyIi3TKr8efvAmBuVhDTXaPh9ZGlDVW5KCGsWdgyuRTMZb9eCQEB7fsUJF
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:22:00.9493
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9563d07b-b234-40ef-cd41-08dea4791c90
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000048.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5367

When saving/restoring the state of the GICv5 IRS, it is important that
it happens in the correct order. Failure to do so will almost
certainly result in failing to restore a guest that is capable of
handling interrupts correctly.

On a save, the ISTs must be saved prior to saving the guest's memory
as the guest's LPI IST is written to guest memory. Conversely, on
restore the guest's memory must be restored prior to restoring the
ISTs.

It is important to restore the IRS MMIO registers by first restoring
the IRS_IDx registers as they define the capabilities of the IRS, and
are used as part of creating and managing ISTs and SPIs.

In order to restore the ISTs themselves, the IRS_IST_CFGR must be
restored prior to the IRS_IST_BASER. This is because KVM extracts
fields from the CFGR to determine the size and structure of the IRS
created by the guest. The IST itself is created as part of the write
to the IRS_IST_BASER. At this stage the remaining MMIO registers can
be restored.

Once the LPI IST has been created (by the aforementioned write to the
IRS_IST_BASER), the IST state can be restored using
KVM_DEV_ARM_VGIC_GRP_IST. The SPI IST gets extracted from a userspace
provided buffer, and is transferred to the host-allocated SPI IST. The
LPI IST is extracted from guest memory, and is written to the
host-allocated LPI IST.

As a general rule, the IRS_*_STATUSR registers can be ignored on
restore. They are not userspace writable.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 63 +++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 38eef7cc63e3e..1c55f5040757d 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -201,3 +201,66 @@ Groups:
       -ENOMEM      Restoring IST state failed while tracking pending inter=
rupts
       -ETIMEDOUT   An IRS save/VM operation timed out
       =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+IRS Save Sequence:
+------------------
+
+The following ordering should be followed when saving the virtual GICv5 an=
d
+IRS:
+
+a) Save the ISTs by issuing KVM_GET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_IS=
T.
+   This MUST happen before the guest's memory is serialised as the LPI IST=
 is
+   stored directly to guest memory.
+
+b) Save the IRS MMIO register state in the following order by issuing
+   KVM_GET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+
+     1. Save IRS_IDR0-2 and IRS_IDR5-7 registers.
+     2. Save IRS_IST_CFGR.
+     3. Save IRS_IST_BASER.
+     4. Save the remaining global IRS MMIO registers.
+     5. For each PE:
+        - write IRS_PE_SELR
+        - save IRS_PE_CR0
+     6. For each SPI:
+        - write IRS_SPI_SELR
+        - save IRS_SPI_CFGR
+
+IRS Restore Sequence:
+---------------------
+
+The following ordering must be followed when restoring the virtual GICv5 a=
nd
+IRS:
+
+a) restore all guest memory and create vcpus
+b) provide the IRS base address by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_ADDR
+c) initialise the GIC - this sets up the default state and creates the SPI
+   IST - by issuing KVM_SET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_CTRL with
+   KVM_DEV_ARM_VGIC_CTRL_INIT
+d) restore the IRS MMIO register state in the following order by issuing
+   KVM_SET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+
+     1. Restore IRS_IDR0-2 and IRS_IDR5-7 registers.
+     2. Restore IRS_IST_CFGR.
+     3. Restore IRS_IST_BASER - this triggers KVM to create the LPI IST.
+
+e) restore the ISTs by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_IST.
+f) restore the remaining IRS MMIO register state in the following order by
+   issuing KVM_SET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+
+     1. Restore the remaining global IRS MMIO registers.
+     2. For each PE:
+        - write IRS_PE_SELR
+        - restore IRS_PE_CR0
+     3. For each SPI:
+        - write IRS_SPI_SELR
+        - restore IRS_SPI_CFGR
+
+The various *_STATUSR registers are observational state in the current KVM
+implementation. Userspace may save them for validation or debugging purpos=
es,
+but they are not required restore input and do not need to be replayed dur=
ing
+restore.
+
+Then vcpus can be started.
--=20
2.34.1
