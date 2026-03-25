Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010007.outbound.protection.outlook.com [52.101.69.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574153ED5D8
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 14:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.7
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774450540; cv=fail; b=u7FyHuhV1xJzE5d7wk5dbT4nh+EA98pW3NdMrUQG2Kl2Jh4HiGYXB7jrVJYLGluka8d6N7QWFQQde8+fRqMvVd3L7f0AefXJ9Vc7OLxh+Hw0j0Ij2QvtHP3ev1yKbtoDuGTXRBsxMtSlbifhvuRFXJC4ghyICncgYt9tKeIu+uc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774450540; c=relaxed/simple;
	bh=yRo7GBJ6no8BEv49dZo1zotteDapAuPmKoU7FWAOqSg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rm44nlZ3YXugBENujqeoKKVX1VEMZzCH1c5i25V0kOo6q11GDKz/+kq48Z2Laf9Np8FXsyYCf/TtnnpP1AuH1u6ps4RmK3iVcYOeFi6KDxhntkPPqh8EhGlUb2aDzT88VzXhBnFHCu7C57Z5ESQdymJZO30vud0Bkk88xyFYU5E=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JP4Ue38S; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JP4Ue38S; arc=fail smtp.client-ip=52.101.69.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JP4Ue38S";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JP4Ue38S"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=VjG/WnTvZhANns9swkFhRoNDBOe2vq3j1BtEDMhc/brGMzxcBin17nqMTQYxetRs9pDH7yrjDOZxz9PA8nyo78qVw90Eai7ycbU8Fimhn7Xa+1Q5021CqQ5jGJ7f8XVqhHHN9wfaaiuVwcRGfjbe1p9Tv/pP5RPMkvQOJEleEdH1rpsIDneenhymbyskA/qEwnKbyGtdE2STOWERPfTQ18jwiKLHpZhoeOhmSZjURD8fU8OMe9J+YiAd4hDBXeZhWMsqGvbzCw1hLNYnUNLVfbDsmZg3IRP9KLCvK/plVP9z78H1BtECC9eUv0ZJk0U+kDMeZnbFBYGfDCChDPOaVg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0C1HXoRBo7clcM23EJ8D08jhPSxypvCLrBhoxW9E9nE=;
 b=ZMLtw/GweoNiMRs4g/z5cbi2vpeIimqUNTH7sMZ898ilPOMhs+HFlhLQ3y7MP07HlEXObT28disLtAZ1U9VzZ2V0S0AZUkbLX3pWmvNDo+bgo+BgDY2rVxizuzFhsH/+FdP6SBaiTsxcwzxaabqcAyrjN5uar9/KpaifUYGGLI7UCAiqdATeCguHZN1ws2ed3Yn5z6D79pLM35nBP5RwdGPN3RFNvuLbG+nxYyMl01w0gQFv9YedlA3eNcRYvleQf8h0riqLQYRhi7/Oy1bOHHHZn8TCB9D3Oq8/PX+dR92qbbg+qXYj/vforqw/OyxTK+Cik3nnsVPmsM9ZpSyzuw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0C1HXoRBo7clcM23EJ8D08jhPSxypvCLrBhoxW9E9nE=;
 b=JP4Ue38S6IB0fVz5OoLERR1HFIUljBsoX4dzc3sBg1WSCGZZazmhRHh/LumB8fxMbAGnVYA9C0SZyOTm7MPM0jVapwUwv+oxB5OVYHrrYtkoHpyREdzomyolsdhN3LnlWMbUyj52G+tyxiJSKBx5qkMZ9dPKX87ifWkOEqi/NWs=
Received: from AS4P189CA0016.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5db::8)
 by DB9PR08MB8412.eurprd08.prod.outlook.com (2603:10a6:10:3d4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Wed, 25 Mar
 2026 14:55:32 +0000
Received: from AM1PEPF000252DB.eurprd07.prod.outlook.com
 (2603:10a6:20b:5db:cafe::56) by AS4P189CA0016.outlook.office365.com
 (2603:10a6:20b:5db::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Wed,
 25 Mar 2026 14:55:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DB.mail.protection.outlook.com (10.167.16.53) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21
 via Frontend Transport; Wed, 25 Mar 2026 14:55:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V+UVjgZQZ2VQur9kdnp3UOyZClLLnqbaq8kyKYgBuv230B8bmXdgaPEse5RccOCJ+W4sOgM7gXFmDmbZ04Na9eWcPKPTIkuKEMiRM/uKGTmaHBddpM6aCRoanJPr70EpHL1HMjN3RkFmPCBbmteUfICT4eb4+u6RuBeOaPvRm9GAidfBnyrYqVuXxWiNa74ByHjZJSt7DrGqCLtxN5epDS+XzsDWsd7psPbaWJqAFVcwV62wLkiO8flx1CAsjnqgSXkv8hYa8PetGtqT7taEIjuvBuGaDAvqOZevfvhKuC+eY9Dgm57D24eFHuvRNnzdlzlszm/Sa9Tzjd5/LVEzvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0C1HXoRBo7clcM23EJ8D08jhPSxypvCLrBhoxW9E9nE=;
 b=WxV5zSneBh+mgwab6ODuJzDG/1UJjxrR5PuKmzrUNLUM06je4mCXGnOiQKbehr+YJtYjQU1F85CBTyJIWTsLj6Yyp0e19oof1BeAuU1cUezFLGhvrotrKIus6YfdOFWR+g0cslERZCbHSp2yCioGbL/bM795TrdYbn3RkKO4eZfL6/Pb4QqIa076AoKuLVUX+tr0nfNIdaeIIAmMOv++DO1rf4BoRTcZcvguxbfndFZfqgJZlGEhqa7FeG7UQ+UWzURMRoXqBZ7mCL4QiSe7B/h9Zt7XyzDLPwX9DRYwrrsjJekZZKpM0R9mz3XdsExxfW+Nk0VlXxtC+ynnXPClww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0C1HXoRBo7clcM23EJ8D08jhPSxypvCLrBhoxW9E9nE=;
 b=JP4Ue38S6IB0fVz5OoLERR1HFIUljBsoX4dzc3sBg1WSCGZZazmhRHh/LumB8fxMbAGnVYA9C0SZyOTm7MPM0jVapwUwv+oxB5OVYHrrYtkoHpyREdzomyolsdhN3LnlWMbUyj52G+tyxiJSKBx5qkMZ9dPKX87ifWkOEqi/NWs=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM0PR08MB11754.eurprd08.prod.outlook.com (2603:10a6:20b:743::9)
 by PA4PR08MB5952.eurprd08.prod.outlook.com (2603:10a6:102:e9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Wed, 25 Mar
 2026 14:54:29 +0000
Received: from AM0PR08MB11754.eurprd08.prod.outlook.com
 ([fe80::3427:f97c:862d:1850]) by AM0PR08MB11754.eurprd08.prod.outlook.com
 ([fe80::3427:f97c:862d:1850%4]) with mapi id 15.20.9745.019; Wed, 25 Mar 2026
 14:54:29 +0000
Message-ID: <a35839df-74a0-46b3-b5e8-7e0a066b210d@arm.com>
Date: Wed, 25 Mar 2026 14:54:28 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/11] arm64: Skip update of an idreg field affected by
 an override
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
References: <20260302115653.1517326-1-maz@kernel.org>
 <20260302115653.1517326-2-maz@kernel.org> <abwXl35xQ2ze1XwJ@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <abwXl35xQ2ze1XwJ@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0195.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:376::14) To AM0PR08MB11754.eurprd08.prod.outlook.com
 (2603:10a6:20b:743::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM0PR08MB11754:EE_|PA4PR08MB5952:EE_|AM1PEPF000252DB:EE_|DB9PR08MB8412:EE_
X-MS-Office365-Filtering-Correlation-Id: e2ccbae7-d4cd-4b31-38e7-08de8a7e9055
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|18002099003|22082099003|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 dO3nQfmYSqFz/53hBJ8OJSI26g953lwgp9YAgkAwl3rpIpIpKn0rga+ydwujbDNAPH69wBhR9XMRMPXwlc8nT+cEWuy9069Q5TpObUUuanAzrHAR5w2NDmRrT5XR5PoEv5IczQRhPfcAt6aNv4917tqYG9loOij6I4LKrEJEleBEZGNx92tu5xOH8avETt/spOaKDxvv2VhJ9goWtE9UlARUX0t3qovgwp1tA+mJ26jo5W7ZRU6erU5sCTmqIVlOQi9dpKrmDaHo+i/6aDwROwlEIEm/ClOKKM1zMFmJ3Y6JK2onj373HVBIFL/QCuyj7b5WYvWi62/FMppKgPVOEcqEVsXPqigNiFJGfUEaqlVJJ3IQBYjXH4T4cKSP82UTzBNuObdFX5Qrv2xUA28cA+gFmiqeM+MBAHY6Rt6YIfBlJvnWDGSz65R3X5mGey8I77WzSLstABkcppPb5CIOTEfXDQx6iLizHRgcZWUdmUGLumaHunNcAOTdC/Wd5BnFw5HBiU9r4Ilo/zB0l2smos6FPi5yQeZkHo048jvqc1lzxaKJeTBE7qDubZ9POpGjY+5pRgj3jVTMU6kcEIxjQsaEVAjwM7NZveOHODubPEtp00iiAqSMG+fTDXaVbEY61ZKLkZoMKQ9WVRhYF9VlZ0LZOpQ923oOpBVUoW3HkdZX8n55Tmp1cUdsMJMmu4oggVKG4d02CBes4X1STJ6w2r6qzQR2T6JBhIKH/kcB7Hk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB11754.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(18002099003)(22082099003)(7053199007);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 S+gOWowEj+6csdbCz9YTs0X1raqbkA0QakGAM5As8PsOyCwFOBcuwMOVegKXDvyLOnKkTCUB0CNUWLKjdHJwmK421Cq8xpNZsfo5djh85swUj+VYDlXgkxcmXT3jtm6RZdo7t3wQ0TqRSGLC8ItELvUWEubp4h1b1eR4o72Zw4cG7JTUsRhnh95smwR5Cm7+lYAbUTY45ZK+YuF7ky+tU6Gy7UytD1dm3jtopZgfMysz6JZ+YJ4MAFza028t7BlxJg/GaCJriCHjA/SfXrs2NCZZLqkSN0Wg97hpxlAh6ohBOHGV7V0qmViJwi31S+agXz5U9SdM3EOgVAkqp0/GAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB5952
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DB.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	375d7d90-a7a8-4b8c-ab5a-08de8a7e6aa3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|376014|36860700016|82310400026|35042699022|56012099003|22082099003|18002099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	lw3q+klnjwtg3zj1tk32XLdNjElm+wS+TcETLAuVdz4zWjeHfSY2T9ExCnuHkliAsAM3Nl9T9NCXrxnY0H8OC07Rbop67FxrNqnKVdjUwD9fZ33wW/zHQ3kftBGS6Rpqn34+ioj0s9RAUmotLemhdiQGCB1aKWKQyE7T+bzvUP5fWUIMNcccVZZsQiSxqAKYGNRuobhaSpqzZA7LyhuBchL2dIawRWzFYdgrxwUxJWBSU/i4Q239rNaZwuUBtSAsh1bFwdzTC1gu5GC6orTCVZv1IfuTxShebTce9ddJxFBBNZq0hDgWNdOzZbBZUhyL7Rb3Q0pD6neabH/B8aVYTXPzfUWr5mwKiiHEvP1Co7DAKJfA/cqZSLuMguFQwjNfStWgAtppsz1zNjoOGA8knnpU7Ex18cXoBWoWFCN/fHJGPvbXgq2WHBhRFgXD7AEAxCBt18/cSmT15OPRnTrP5QE3BA+40vHYYYEKVF46lAxOxIZHsGdMPJvrKpD+LvSHjaAmEP4CKIkz8tdO3BEfDu/LtoQUZgwmhASkZHZWj2+RIMsjcYfO0ZDSDM+kJvylfQr3RLpDRZQ7godSFngBPneUXt2nblppZlaKfj0mGGsUkAkkmubW40raPuzSrs45jQGB8d6Ll+B0q6ESa4PomH8pJNV1rFKj9rR8BNL16+mW+dDJ0+QMVz+STA/fJd79vG8yA+RQMxqYKVhM5OQrewGV/zZUOdbiFNOhjugKMCu5OSyH8BjJskFuBq5KwmCR0+sy+I6TiFmLyNeNJROfBA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(376014)(36860700016)(82310400026)(35042699022)(56012099003)(22082099003)(18002099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Km9EajMiuooXLbkoNijGS3WcUhbmht3CPlnzHLSA55x9u7Kng9/Fzxa3JcdmCh8b5ogffERbCygGKca1RnKcksWyhWQCTjiGjefshzGW1zecPy+7IVDbmRP9E/hVgFzRaFBzHc6+eqaXc3lubInBf5zr7TG7vigg/WiN0isKFlcGFUrC46oF2GvTl1UwugtcbK/CFK1YGQjvtka231Ooi/deGVW3WR01WPwVitJz8VE9Edyrxfu0u6YnA5G2gi4XKZ/O7+GeXV5Ke6YTzaBRjx3aVHyrLgBlfZNI3A2d/eg7Wuxpmat/kx8XCFR93/1cZWAv7EMSQSHmWAsU9N9nIPgtrzUqlI5ZF4tFGcBavaSCF+PJaSXcnRlJJF5Rokap/fYW/ltsAmMJqyhxUEddxWBdPP3cvzm8XujY36h7qsDyxBG91SbNFZicmZZlcqFv
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 14:55:32.4220
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2ccbae7-d4cd-4b31-38e7-08de8a7e9055
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DB.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8412

On 19/03/2026 15:34, Catalin Marinas wrote:
> On Mon, Mar 02, 2026 at 11:56:42AM +0000, Marc Zyngier wrote:
>> When computing the new value od an idreg that contains a field
>> affected by an override, do not update that particular field.
>>
>> The value computed at init-time must be kept as-is, as that's
>> what the user has asked for, for better or worse.
>>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>   arch/arm64/kernel/cpufeature.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index c31f8e17732a3..28fc77443ccd3 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -1224,6 +1224,13 @@ static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
>>   		s64 ftr_cur = arm64_ftr_value(ftrp, reg->sys_val);
>>   		s64 ftr_new = arm64_ftr_value(ftrp, new);
>>   
>> +		/*
>> +		 * Don't alter the initial value that has been forced
>> +		 * by an override.
>> +		 */
>> +		if ((reg->override->mask & arm64_ftr_mask(ftrp)) == arm64_ftr_mask(ftrp))
>> +			continue;
> 
> I got lost in the in the cpufeature framework, so I may be missing
> something.
> 
> Let's say the primary CPU has a feature field with value 2 and we want
> to override it to value 1. For e.g. a LOWER_SAFE feature, boot_cpu_data
> will stored the overridden value of 1.
> 
> A secondary CPU comes online with the same feature missing, so value 0.
> With the above change, we no longer update the system-wide feature
> value, leave it as 1. Later on, for a system feature we may turn it on
> even though the secondary CPU does not support it.
> 
> In summary, this makes the overridden field sticky for secondary CPUs
> even if they don't support it.

That is true. I think we should let the secondary CPUs alter the values,
with initial CPU feature value with the override value set, the system
could then choose the safest among the override and the others.

> 
> Unrelated to your patch, I think we can similarly fail to reject
> secondary CPUs in check_early_cpu_features() -> verify_local_cpu_caps()
> because of __read_sysreg_by_encoding() which uses the override value
> unconditionally. From this perspective, we are now consistent with your
> patch above.

This is true as well and the override takes the priority and with the
wrong level of override value the system could be made to think that
some features are available even when it is unsafe to do so.
We should sanitise the values read by __read_sysreg_by_encoding() with
the "overrides". I can cook something up.

> 
> In all cases we taint the kernel for FTR_STRICT features but that may go
> unnoticed or if we had FTR_NONSTRICT (does it even matter in this
> case?).
> 
> Maybe that's the intended use and blame the user for passing the wrong
> override. We are still slightly inconsistent depending on what the boot

This is correct. We should at least WARN for impossible overrides on the
secondaries. (We only do that for boot CPUs today). The other issue with
this is WEAK_LOCAL cpu features where we use the capability wherever
available. May be we could reduce the severity of the warning to 
pr_warn_once().

Suzuki

> CPU supports where we still decide whether accept or reject an override.
> We don't do this for secondaries.
> 
> Anyway, I'm not opposing to this patch if that's what's intended. I'm
> sure I'll forget everything about this framework in a couple of weeks.
> 


	

