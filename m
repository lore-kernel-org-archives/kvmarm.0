Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013047.outbound.protection.outlook.com [52.101.72.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A445E3CAE9F
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 14:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.47
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773327312; cv=fail; b=aZhJj/gHxp2Cufb2EDJZ97al2kfdEx8PiX8nXM9QZ9/VGCw0BfQ5ZXR9M73ckQ2zqwlbsoOBi38WHr7Q/ZACxTBQBUGNQc26pqdj6IVvBdrr5yJqCUKPCk0d4w2JuaSA76nxL9gFc9ohsCIAXIpTwL7xrUt1C9oui4yKOqlla2E=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773327312; c=relaxed/simple;
	bh=VZ0u05oTw4V20d/jXYvNW6I4CzrN0CMbqRdWWjQxGpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jpmADyBlXuvLa4TZgX8dr9Mcyr+lGuiz9Fbf4Aic8P1rstIIqB/rj10xF+2Q1WYtf/Z2BiX7NamMAwdzGu2V/q9DZ2Ddd+9pZbpNPlEILDxwdlICeGefZIfIHeu+zOr1iQcRj/O/KkUAHq9N/2/5P+QoL1Ualu3Hu02Imv4EJd4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TQv9gn55; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TQv9gn55; arc=fail smtp.client-ip=52.101.72.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TQv9gn55";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TQv9gn55"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=o28mR1VyCuaMffrP8UGkguSFyUP87DfSrGxlMjz5CJ+mOc/xivcNsDfMSgQp0lY/Q8ZoZukVcxfxKQxL+CnBpkgKRmeD8Wv9XhMPSEo36Je+yazQXUIKQR1C2Ap6BNde9D30QaV9+DaSLNK4pa3GBmI4HJSd+X6hqa9KQR6mAJsXDXhyZBFNe8qYcATmPdhSthG5LhVCyCDAvfuwFO0w16wD6bfCXaTdaFYX1AneqLRs14OPRDPs+tnif7UV3fsRUaEzeFrmNlE/BNJ7BGrdPdvUwAT15SnVgNXp1MRv24/6dAoqyenNFjZ00afhJkNi5oXZ8u0aHzDAnQb9gT/H9Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SOAGdEz4BnXfQ+l5Lym/qKm/Tqn9ARgqW0SEaaEOsoA=;
 b=nvh5GTB/39MJmDrpTlqafa8Wo8n3kch/yDLxFQMlnmIsyTA6XkTDdp8yIrGGpz0OzYSe34u/yA5fDqLdqvqaFXImECp+7rLy/p1UpqssYE5E3USBUX2Arovkzrf6P/XbFBTThWn27DQ8DQmcyn3Vos+6V4Ee1qy8OEC6cG8B26yOr8KUpCjtqD3v+LCkyZKI5QSG4hsnofJ+vQpbRg/z6R1YKeNMRCNRH0RchW8p+Oe6zlSGBrgQpWZ9UZMCSES0JmLZyGMx6DfRgVGOGKVMPf4hZBpZEXJwh/Rq6CJS+XOWBdpNo418jp/VzQn1hkcoA5xtVPqqx+XhQxErrRb6YQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOAGdEz4BnXfQ+l5Lym/qKm/Tqn9ARgqW0SEaaEOsoA=;
 b=TQv9gn55ioia35QVwQB5BLTG2ZRz8HOUuSKcSeTRsMsv4TwUikHxVXbaaFUzdNXnk8JSZa4xqhdkTB4BrZ1+gNZSzVtqO4wXet2hkgqf2p8ZYFB3ILH5Y4xj4yf3wdVsdJA+1q7ADp3n/ErHUVenkTVLfCc3q/3Mx9tPCIvggUI=
Received: from DUZPR01CA0069.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c2::12) by AM7PR08MB5302.eurprd08.prod.outlook.com
 (2603:10a6:20b:103::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.16; Thu, 12 Mar
 2026 14:55:04 +0000
Received: from DB1PEPF000509FF.eurprd03.prod.outlook.com
 (2603:10a6:10:3c2:cafe::db) by DUZPR01CA0069.outlook.office365.com
 (2603:10a6:10:3c2::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.27 via Frontend Transport; Thu,
 12 Mar 2026 14:55:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FF.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.16
 via Frontend Transport; Thu, 12 Mar 2026 14:55:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BnFNUEB9DZF9tAkEHY7A5LTyAlvuV2jkFWtISF3TZu1jwbuwt5BY706kpMgaWxuVM7xMkedKXbkWExQZupy7by9yjqJvBu/9xjkGDr8OBLNN4Y7CQX0ubMOm6OjZwP41M4d34Szp3xuUjnlLxm+vNSdIPFpgqptCkCcbKxnCFYxL17+9nMoAJsAcSy6vOE6aaxIGDRjFSEbSlIiR9iwD7RjCVK/tRf++XriOM0jPAudc79KlrHBjULh+dZn5uaTx+oaWzumj33JP+nGxXjo18Z4aaFbDyD/moOEaG9cln/7V3ZLuV3D+uL98VdnMTFb8IBLM48hmsA1XlVJgK/EadQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SOAGdEz4BnXfQ+l5Lym/qKm/Tqn9ARgqW0SEaaEOsoA=;
 b=hI/PeyslvE2ytsn8By+SZ/c1FDSCx02yB6+e/DmHLP5YvhKVKBDJxofEV1XwEAAws5h+TRQ88uLmGV5i/U0YNqKx+72fJcp3r/I3Fayo4JpJ8nEBv1mykqobGMzJqmikW5rugVhgWaNyXLO450aogxXOwX16oC7Sv2pSTRqLGsW5TYEvWdSywNOnYmSDC7Qpk+/tWOeoGzRfIZK3V0MQoPODKQxUJKeeTLM3Kvh/lcFpvZTlye/DlhmlMjRN2QFDwkSzkqzg9BKcp9Fm9EIO805o5dozUs27SkM65Y6VYwR6Ml+dSE+/gmxTtwV+nqgc3wAV0hD2FJK5utQeAS6Odw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOAGdEz4BnXfQ+l5Lym/qKm/Tqn9ARgqW0SEaaEOsoA=;
 b=TQv9gn55ioia35QVwQB5BLTG2ZRz8HOUuSKcSeTRsMsv4TwUikHxVXbaaFUzdNXnk8JSZa4xqhdkTB4BrZ1+gNZSzVtqO4wXet2hkgqf2p8ZYFB3ILH5Y4xj4yf3wdVsdJA+1q7ADp3n/ErHUVenkTVLfCc3q/3Mx9tPCIvggUI=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by PAWPR08MB9711.eurprd08.prod.outlook.com
 (2603:10a6:102:2ee::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.15; Thu, 12 Mar
 2026 14:53:59 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%4]) with mapi id 15.20.9700.010; Thu, 12 Mar 2026
 14:53:58 +0000
Date: Thu, 12 Mar 2026 14:53:53 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	oupton@kernel.org, miko.lenczewski@arm.com, kevin.brodsky@arm.com,
	broonie@kernel.org, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, joey.gouly@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v15 4/8] arm64: futex: refactor futex atomic operation
Message-ID: <abLTga1swfaHQzGg@e129823.arm.com>
References: <20260227151705.1275328-1-yeoreum.yun@arm.com>
 <20260227151705.1275328-5-yeoreum.yun@arm.com>
 <abLQtbbYidcmPg-7@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abLQtbbYidcmPg-7@arm.com>
X-ClientProxiedBy: PR3P193CA0013.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:50::18) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|PAWPR08MB9711:EE_|DB1PEPF000509FF:EE_|AM7PR08MB5302:EE_
X-MS-Office365-Filtering-Correlation-Id: 119502f6-622b-4176-9ba9-08de804757df
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 ewl0X/PdkqG2+AKnB53jA3p0oL8wuP2uTjpYQXi1LqqHyHxvuYmze1CE7y3W74SRUXM+Lf4BTzuI75j98ckvY/+gOfifowLZ4w+Yt4MVZdLO1wRs81an4wnLO2mr2yHcvorHNI3A+htZljyBiihAr5eNnQclNStRIXxYFTuK0R5d2db5ydEEcoadFCVnr/S/xx0JumGQh/aA/JI7cAR1LYwZX5J7ljaIMYlcm6vqqJYEFHjGpi26dUUGsd5J+bfS4UzAvitHIw2ufsrk/KwNZS9lh0WR6g6QLpwhHdLa/7FhUNNrGUiWgUVQ441aETU6zl8THspEVbcSn9SvGQnz777clRMz6AlCSeIR+s+b+NsLeoM93R5d195A5RQ7J8YVkxLfpx4Yfc9v+1wdbn7dCr9uJU72vk2LJindLcxCuN6GMEpQB5Dc8dCAgye3rxs2yD6ZgnabW0OxKWmzi9GdM367PiqaucixWysCKHJctsYM6cNaWy6saTxiuIbzLvQMlugjEUgQs3xuDF/KSUEmsWn6+9hWmM4KYws9oD02ix6f2zQxIthEPF3Yyb1NtxQtTpPBdO1HOyzo+6Ils5ZUtwk9nG3IbykX/1MuhL23w5j1TzjLde8ieoFYqRaI1VAurCvQTDSFQV0zEfmQNx4Kf3SxsqzWTi+m9RnFqEcccH5vMUWphEnHLNzAODnTxmAJTctynN6v//tgIowYgFfWB/gyh6O/Tza5E0WQ+Gi45Jk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 grxEVzqF1VW4vkGu4nvbnPN4Vws5yMZuI5AetQc8ckpL/92V25jHJsDTnhsqsQ37XZgfmW8Ze9lW3rRDx3YufXjjvut4saSodbhyKUBPdo3qjxcUk6cjnFl4g2cPJTnHqUKdCS9OOw7dmEpQ3MdgS8PM32cX8gu0aO6GCmKKfqGHiIb6cnIiV9z2RNjv1wknB3fHtsleRaAIWPR/qK8W9H6PBymumCEd9u8T81xKXPZ3byZQcVsdrur6g4N6zg4mOGc105WuU/qEj5FqnGLHyZWwEeo9GQtHsYpW8ZN4N/VlMTgEb0gkfKq1W9Fw90sqTeuou71d0pqbP6jjWtk20w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9711
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FF.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	97db2076-9ae8-4225-b733-08de804730a9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|82310400026|35042699022|1800799024|376014|7416014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	pq89WL/obehPDj8K/EiSXvhSaseHVFXCzJyiY3gf+YpdUOyhlvF3jc0mMajEKpyoDrdWU6vsxxicFMSB2bojWuP9C3UTVhnYR/5D19UP0ZbToTptVeUjZ/M4eD1+keoxewbXZpnHRSMGjr6xZMdiUC095q3l4Ru259xO5nu4Rz1jA5UzaSfBndaCeXrOjGnVnNKhGXo1H8Zb9i4doJFZC7KPqg3fLRljYK3MSv+nsTjWnxneAX+l/qo3eQvB/Z2gXI2EWeNPsnzslikmtqg0iWHiWwldnBLAiH/Z10BA4Qw1PgmRV/KPCEoM8LHSQY2JbKOJDiZwxfJVgm8TyU9zB1GMgVezbHvLnzM3TIyPrL4uBZSrMWpdR5G4Nb69CYQJes9b3OaNM3JtUYDG1bnPFchs/5iDILeC6j+7nPJ/lxSPzhg2a6GmJoArcmmR0Vc/8cGtRHECYhCh4WkluVFSSv7RJm0RW57zuVgXzfqwStJGoahGYXsaspWubTNGwBW4W3IAUPKicGG3MmfySQoJanMRLJbtMEgm31W/HG2yKZ0k0Si4EtSv+b0FIr6hNCkFm3Ow385pZSwcfqDPIk2ICk0JM6VbikQB+IC0FSmRM9ECyzfK/9V9pg/oZ7dQkQkGLsEZXKmPxhoeyTM/yuXDw/h0RWzDNdUitmYiQ4ZGmBg6I1JgnqMGhPsN2Anq4+wK5P7F9l2aZkhnepCLaZCyyhXiZwfsYdVdFzjLeOtQOLCX5p9JZxx8r7SsXvMusdXHaTycFPmpO4xlvkDdHvVPQw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(82310400026)(35042699022)(1800799024)(376014)(7416014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	beeDS+lGYVjmLf6rUrkNaVO1U/tqDDYeGeDurvjqUDogKkA1m1Siq3ETnArkXDl+5E8eqqTkQg+R0dwZvZbQhxoM2ELrDN4GCjl/yXjzLwXyjPl9j76qjFncCUxrtM44pF6fpX9OPWtA/NAtHpZR3m1zFQGl2u7Qnu9naDT7USLd0SRd1szeiYTrfXbK4Ly3d+thqVlC5mCXV7kEFCLTvAHiM/S/jA0dyvYM7bJs+gVDNUgBhiCSi7ZccZvj19MURSpC+XSGppA2Uwy7FW9TeVpL28VsqIJKreZ+FtisE29W1oUM9Oe1f6jkRQoCyP3rnI6c0g7oZ/PdUM4gQdrCK/fpzmTGRcx9W23rL1eT5RqEZjBaI/wbPtvK4SR94SJWuZ07+CngP8AA00vLd80EWmbPeAZ9wdRP8lth2zUROPBv7nYpmgeAYdt43lElIyTh
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 14:55:03.7373
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 119502f6-622b-4176-9ba9-08de804757df
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FF.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5302

Hi Catalin,

> On Fri, Feb 27, 2026 at 03:17:01PM +0000, Yeoreum Yun wrote:
> > Refactor futex atomic operations using ll/sc method with
> > clearing PSTATE.PAN to prepare to apply FEAT_LSUI on them.
> >
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > ---
> >  arch/arm64/include/asm/futex.h | 137 +++++++++++++++++++++------------
> >  1 file changed, 87 insertions(+), 50 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> > index bc06691d2062..9a0efed50743 100644
> > --- a/arch/arm64/include/asm/futex.h
> > +++ b/arch/arm64/include/asm/futex.h
> > @@ -7,21 +7,25 @@
> >
> >  #include <linux/futex.h>
> >  #include <linux/uaccess.h>
> > +#include <linux/stringify.h>
>
> Nit: what needs stringify.h in this file? It get removed (or rather
> moved to lsui.h) in the next patch.

Thanks to point out this. Yes. in this patch, stringfy.h doesn't need
and patch #5 already includes the stringfy.h in lsui.h.

I'll remove it next round.

--
Sincerely,
Yeoreum Yun
