Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010070.outbound.protection.outlook.com [52.101.84.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F27D369206
	for <kvmarm@lists.linux.dev>; Tue,  3 Mar 2026 09:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.70
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772531359; cv=fail; b=HDkbADH3yVf1urb/VNXwO8I0rUtYLwKi8W9df5Aef5OS6tJwZMXBadB0KLxqyhxlcRN3Gl+sjgFDc9lb/mBdwmbBnRfWjV/sVVjmejGsLzv8ATU1FwoyhOYUo+K7Nf7gz0d5ZxDHMvd+Y8vSG540yMSomvYw5k405aYXeDBRGdo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772531359; c=relaxed/simple;
	bh=GU8wDRmKNIVFRzsVV+IEYBg72bdsvLzvj52X2iSoNh0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GoI4Swa9r9lGtVy/wUKCPUiY5Z13gxL/v5SBgYkwOD5l+z0qo7PlEkPmugJf95p2z4m1vBmB9USaz3cbdM2sDHSHWsdkF+9BbiMSCVwVNLlhgKrBo6H+C+CXa9hZmrmi9Qr+FUBbaq3Nuw6wNl6A8Y3usDQkuVPArQrGUExBRXY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=i9Mts7Di; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=i9Mts7Di; arc=fail smtp.client-ip=52.101.84.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="i9Mts7Di";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="i9Mts7Di"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=euVcBIo1DEEIGylwaKNn09wA2QjNVdsLt9CMRrBEBVUYHcCyvVYPINvYucdxYWhAyWt/bsY/ADhgSOspCfL3nIkx7sZTZbIxxM/KYx5GOH2z3E2VmIOK/tuOVvktHNdYa9ymm0xiEi0JX4F1ko1e6m4nEd/wU27DvKpYO6XXtuIYk9ZyDMc6Sv67F8mJ/gd1odBbZv3Qp/4tQvaEv0gnfNfBzqwZUjqhzhJl+ceZ9bQauz7KTfWqeeD45cjyz3wZPxi3DY5x5WO/CKZufkD2PVznJ+zw7V79OJP5Lr1uCwcJObZ3K1BNEzIEzNi6Cn+LCDhna14YtHDXn4Hgmq1iFQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lziis5e1fFvAu3+/xER+Xl+vPJkoeFaSj2B1kA81urc=;
 b=i9e3Y8vDP/SiAH+0+fIEECdbGW3qpkQSpfoxJTL8z7f27xpnc+Z8Zs27hVlZM6GuqD8z7ov4/aZrPyBCcMZ+4Idh7bZclB0bhEiWH5EbfMjNWKuxA99KdyK8QkCVEQIv1TDiOhBgdEpuHsvVkyEP3WvqIldKA6IJh/u4Rgsa97LsUOu4uBlvoGadHEWkc0IuqmH5b0auYIubGTdW3TeMWXQYX9PX3ItNFg9H3oWTW3Jcsa5erbnwb2x9lhL6zKhQmstVt6ZY6MBlhYhJn4fvy+1LUqrbpyLQgpuJREn8HTQVHeMStjHRg1WfaY2dNH02BzJ7xjnqbQ6W0hglwa8Cxg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lziis5e1fFvAu3+/xER+Xl+vPJkoeFaSj2B1kA81urc=;
 b=i9Mts7DiC8HiXpN78xlJgVnZB+G7RfkrzrCNJaX3wfbTdLRoYTtIsEIgH21bil99cHWgmmFlLbUfssdBC0oSJM+t0iGrI9k7fGFNozzZ7Xo7/DTG/1jySBHZ2AnASj6+VcApvnkVFx3rS7zr9QEwGyZTKV7W3jcVQrgLk3tQhUg=
Received: from AS4P251CA0005.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:5d2::10)
 by PAWPR08MB11511.eurprd08.prod.outlook.com (2603:10a6:102:50b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Tue, 3 Mar
 2026 09:49:12 +0000
Received: from AM4PEPF00027A69.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d2:cafe::92) by AS4P251CA0005.outlook.office365.com
 (2603:10a6:20b:5d2::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.22 via Frontend Transport; Tue,
 3 Mar 2026 09:49:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A69.mail.protection.outlook.com (10.167.16.87) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.16
 via Frontend Transport; Tue, 3 Mar 2026 09:49:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u61wZDjT4ZxNfSM4atv2LnUequ/uNZjgU0N+XvWBSAIS4qgCskl6Eyu2nPMXW3jFF/SOea9se6nWOiiiINkRqavizv73QC70rUK1SKMLF7LT4wFRzkKwBMkb1DLe2iPNoeaYrzCAw/dnV9cvvfXN4hGdp//4CLaUis0PTa3ZVgUrB3iBIiqDP+XET/w1ldWZ0rBEtT3dXQmM2NRMNwmcQJ1PbeFsIpUOPFRZqSBiBrDZ3gXm+g7YwR8eu2uWO0HMtvGtqeW6//5EfSxWuNRzBt+fkWW5Ov0ICzJ1BEk0/ylgVqVJIKn2SoXHImIr0y72kOIbrndQjX6JC4zrbU1jYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lziis5e1fFvAu3+/xER+Xl+vPJkoeFaSj2B1kA81urc=;
 b=CZa7xoN/Z02+wmg6AIJHW0oIm65Fw2aTgYLcOKRDPGvvNkE/yF7EDZsA85K3oeis5ZdUl+AcKzpvgq2l77AsrnAVW4cbxA/09k3LNn4IXbZWQkNI3xbmwp9orQLbUqUoCfmw9Fcj6/rXciNAUuamf7HXmFtfrIDP8EIv/NZlz03WsHoM086wfr8J6KV6zvNsRHuml/K7X4D70Acy58zkUt3g974SvUSOo+uCRDlw34REcdSoh2kudTBUpYeFWEZrwePIzbatSS6+s80V8j+coX3fLvWNgGRFt0cW466BUBW+93+GQKkOtQrikfLers6e/0NPQ/ZC/+uxOdZviMZGjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lziis5e1fFvAu3+/xER+Xl+vPJkoeFaSj2B1kA81urc=;
 b=i9Mts7DiC8HiXpN78xlJgVnZB+G7RfkrzrCNJaX3wfbTdLRoYTtIsEIgH21bil99cHWgmmFlLbUfssdBC0oSJM+t0iGrI9k7fGFNozzZ7Xo7/DTG/1jySBHZ2AnASj6+VcApvnkVFx3rS7zr9QEwGyZTKV7W3jcVQrgLk3tQhUg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by AS8PR08MB7943.eurprd08.prod.outlook.com (2603:10a6:20b:53b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 09:48:07 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%6]) with mapi id 15.20.9654.020; Tue, 3 Mar 2026
 09:48:07 +0000
Message-ID: <b6f0b0c8-c2a6-4b61-a0cc-482450c092f5@arm.com>
Date: Tue, 3 Mar 2026 09:48:06 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] KVM: arm64: Disable SPE Profiling Buffer when
 running in guest context
To: Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev
Cc: mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>,
 Fuad Tabba <tabba@google.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Yabin Cui <yabinc@google.com>
References: <20260227212136.7660-1-will@kernel.org>
 <20260227212136.7660-3-will@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260227212136.7660-3-will@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0040.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::28) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|AS8PR08MB7943:EE_|AM4PEPF00027A69:EE_|PAWPR08MB11511:EE_
X-MS-Office365-Filtering-Correlation-Id: 7480d260-b9e1-4ecd-2b61-08de790a1f61
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 fxLUwy4mdlfpGs9Ll0aHtEnWQfWzTuzkD24phbVH0cjbEFzuURCKmVXI4qzLV5mKePx3kZkK0oHJM98ybamfIkTCaAwAhcbU+E7zaeMAKV4yvCOi3IposUmDsREQ3ITACn8a7gC2lFux2PhFdfsTXKibqD31Yg+OC8oW69MuzJ4t/I6cF5ugBogqY6uC5XWHHSjtPniNphAtbBoFO4ZEr6RiY2aDEgeaoA8iYxtZyY41lgxKMnS5fy1eFF/TNSLwuhPPkW/Gnw16scpJZPsNgO9zMUzRVdT0hxM4mZlt4BSpNkGCtwz3gmriZFJzmQK1B7ZWb+PUe3i7+pgx5YdphVTHY8+y4QUGgwX8kqgun5p41dI4JQxMw8JM13qs7BZ/43EWVA1xNOIM0t2uw250Bt9Aw3X6U7ZFuCASRcoWdHunyWEp8DDKcuW14/THrS3Nox/0A/aurRZlOhOHdvOke2MalooBLNmz9LImAGTQ6f7V6pWfWCWo/h3KBgjmIznP4r6oqQLVCYNnJo2qJIiPOXEPTw5bcYrXIQMqTnwgLoel5lO1b4YeKpyD9s4tvDc1etUTrlRpmtd4nMfw3xJOna8QJCPf09SCnZPLlN/VDRrIq8hjztcg4pzYLcS0MhCB/dkWMrdxeEH3dcDvJlJJUdx/XWB2wwTtcVSY/eWIj4AEteXmgGkXwj2GeFbw4qew6KzQzBbiRN3EOdi0vLaY/Woc+9X6iI7LKOAprSgl+0A=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7943
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4566fb2f-8fb7-483a-8d15-08de7909f923
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|14060799003|1800799024|36860700013|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	yOxCXjwwXCmAvRBykNAX1vc0MnOaUvidoyLZJ4h4b9TqHreey/ad2G9gaZC8Lvn4E4YSaTMmb+qVq2BT3GLHcTrzyYViAcWBNIjojDB6looAg2Wbmbp/V8E13jbCg0HqQMSSlS/yHxHNfNtBNIYUJ/e4LM2o3KxPhbpCMaLjx+NfBidhXFZHnTmHf0wxyr2y8JCePsUyi5Y/HkX9567FmqqOOCuCzYWP2Swwwi/95yMZFGCpJuwWpoDLHnSHYSB9ZjH0OCYTJ4EohtXyLo0NSUbdjlXIYkGhHLbc5rG+1DIZIjT4NsR+u6wZoB1ketHbCHFMMHASEiq6I7gCjFtv/9dcwPwgnmuqo74SN7SfSRphsoLEwr28150dCGMzg0rY58eBhHhyWEUV579zygsx1rl44Fq5vBkkkJ6KocM4ql+7kXr67fpGnzJOa7C/N3j8FJ3PsCVbhK8xHXml0mWSptG/8PdJxqBT2TJW4aMf5AgA32RHhqyBxa067mdNJTZSvHbdnF9bouLMFhdeeQcOSIk3GNi4M0NWN7hDlniMToQ1D46iRcMmaCfzjbBTNroQa0qjmAhV916ylnWn9U6dfRp/NlMdeXIN/H22t1XAPbCOs639abuRCQhwAr+ddw7AZ9a/W47JkMQtUqOgYdTUvh5aFY1WTIhjvIiYn/p8F1SmyNFcY3sJz6B2paCFndliLsQs3B19BLggmZRUBZ9vAtyziWoVtCCqhjBWOyQrHPSajsWWP3Ui/PFzgkNJTOoXWhUS2DgJQaIVJVhjsXXu7yGp6Rnix11TRxpC/OFChz7h/aM404DlbGSyDiCvYadsvKoiYHl2qsH5tO7SLFb+/w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(14060799003)(1800799024)(36860700013)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TT2SKs931JEYPjjvbrDFE0jsvVp5GUrIPJ6vtMd6hbpc/ug98MjEXAWCNneYfsUESAT1c1IbAqmxwQ4pE4kTO7dbVdKJZg8Tv0uNCTEdDMwa7EoWeJ6xLvWHRl3eitCskOwqQZtjaa3fiOZ8mqFMc5krbsDS30SZN0RL5jYOfz7vq8huGFppefgVWasTZft8XtVPqLgekpmQfS3ODgYFrmXIJHZNnyn+NuO7nEkjSxE2mRG5A2HYYXBpVcHB1tOJ9SoQM2NFzo9JW3UFIrusfgT6LASVmv1YPdkRQSWG7gyEfFrOoGr7WaejzF7fCROOXXfbGCjD6DTvijZO1M7NOyfsLZRh+AMgmigMfLxQb1YRT+nDGypTIju9b4dwdfJnj6GPc74XvOqon+EtEaJZ179AccAOv9K1/G8ZWi0gsBa3niD/HVJWdHd+p3N+E6Y5
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 09:49:11.5255
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7480d260-b9e1-4ecd-2b61-08de790a1f61
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11511

On 27/02/2026 21:21, Will Deacon wrote:
> The nVHE world-switch code relies on zeroing PMSCR_EL1 to disable
> profiling data generation in guest context when SPE is in use by the
> host.
> 
> Unfortunately, this may leave PMBLIMITR_EL1.E set and consequently we
> can end up running in guest/hypervisor context with the Profiling Buffer
> enabled. The current "known issues" document for Rev M.a of the Arm ARM
> states that this can lead to speculative, out-of-context translations:
> 
>    | 2.18 D23136:
>    |
>    | When the Profiling Buffer is enabled, profiling is not stopped, and
>    | Discard mode is not enabled, the Statistical Profiling Unit might
>    | cause speculative translations for the owning translation regime,
>    | including when the owning translation regime is out-of-context.
> 
> In a similar fashion to TRBE, ensure that the Profiling Buffer is
> disabled during the nVHE world switch before we start messing with the
> stage-2 MMU and trap configuration.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: James Clark <james.clark@linaro.org>
> Cc: Leo Yan <leo.yan@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Fixes: f85279b4bd48 ("arm64: KVM: Save/restore the host SPE state when entering/leaving a VM")
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_host.h  |  1 +
>   arch/arm64/kvm/hyp/nvhe/debug-sr.c | 33 ++++++++++++++++++++----------
>   arch/arm64/kvm/hyp/nvhe/switch.c   |  2 +-
>   3 files changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 1532ad2b2ec2..d527c77977dd 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -768,6 +768,7 @@ struct kvm_host_data {
>   		struct kvm_guest_debug_arch regs;
>   		/* Statistical profiling extension */
>   		u64 pmscr_el1;
> +		u64 pmblimitr_el1;
>   		/* Self-hosted trace */
>   		u64 trfcr_el1;
>   		u64 trblimitr_el1;
> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> index 3dbdee1148d3..75158a9cd06a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> @@ -14,20 +14,20 @@
>   #include <asm/kvm_hyp.h>
>   #include <asm/kvm_mmu.h>
>   
> -static void __debug_save_spe(u64 *pmscr_el1)
> +static void __debug_save_spe(void)
>   {
> -	u64 reg;
> +	u64 *pmscr_el1, *pmblimitr_el1;
>   
> -	/* Clear pmscr in case of early return */
> -	*pmscr_el1 = 0;
> +	pmscr_el1 = host_data_ptr(host_debug_state.pmscr_el1);
> +	pmblimitr_el1 = host_data_ptr(host_debug_state.pmblimitr_el1);
>   
>   	/*
>   	 * At this point, we know that this CPU implements
>   	 * SPE and is available to the host.
>   	 * Check if the host is actually using it ?
>   	 */
> -	reg = read_sysreg_s(SYS_PMBLIMITR_EL1);
> -	if (!(reg & BIT(PMBLIMITR_EL1_E_SHIFT)))
> +	*pmblimitr_el1 = read_sysreg_s(SYS_PMBLIMITR_EL1);
> +	if (!(*pmblimitr_el1 & BIT(PMBLIMITR_EL1_E_SHIFT)))
>   		return;
>   
>   	/* Yes; save the control register and disable data generation */
> @@ -37,18 +37,29 @@ static void __debug_save_spe(u64 *pmscr_el1)
>   
>   	/* Now drain all buffered data to memory */
>   	psb_csync();
> +	dsb(nsh);
> +
> +	/* And disable the profiling buffer */
> +	write_sysreg_s(0, SYS_PMBLIMITR_EL1);
> +	isb();
>   }
>   
> -static void __debug_restore_spe(u64 pmscr_el1)
> +static void __debug_restore_spe(void)
>   {
> -	if (!pmscr_el1)
> +	u64 pmblimitr_el1 = *host_data_ptr(host_debug_state.pmblimitr_el1);
> +
> +	if (!(pmblimitr_el1 & BIT(PMBLIMITR_EL1_E_SHIFT)))
>   		return;
>   
>   	/* The host page table is installed, but not yet synchronised */
>   	isb();
>   

minor nit: This seems buried deep down in a helper (with no context of 
what else could have happened since the host context has been restored)
and for now it looks correct,  but is prone to inadvertent changes
causing issues or making this obsolete. With the isb() following LIMITR, 
wouldn't that be  sufficient ?


Otherwise, looks good to me

Suzuki


> +	/* Re-enable the profiling buffer. */
> +	write_sysreg_s(pmblimitr_el1, SYS_PMBLIMITR_EL1);
> +	isb();
> +
>   	/* Re-enable data generation */
> -	write_sysreg_el1(pmscr_el1, SYS_PMSCR);
> +	write_sysreg_el1(*host_data_ptr(host_debug_state.pmscr_el1), SYS_PMSCR);
>   }
>   
>   static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
> @@ -177,7 +188,7 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>   {
>   	/* Disable and flush SPE data generation */
>   	if (host_data_test_flag(HAS_SPE))
> -		__debug_save_spe(host_data_ptr(host_debug_state.pmscr_el1));
> +		__debug_save_spe();
>   
>   	/* Disable BRBE branch records */
>   	if (host_data_test_flag(HAS_BRBE))
> @@ -195,7 +206,7 @@ void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
>   void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>   {
>   	if (host_data_test_flag(HAS_SPE))
> -		__debug_restore_spe(*host_data_ptr(host_debug_state.pmscr_el1));
> +		__debug_restore_spe();
>   	if (host_data_test_flag(HAS_BRBE))
>   		__debug_restore_brbe(*host_data_ptr(host_debug_state.brbcr_el1));
>   	if (__trace_needs_switch())
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index f00688e69d88..9b6e87dac3b9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -278,7 +278,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>   	 * We're about to restore some new MMU state. Make sure
>   	 * ongoing page-table walks that have started before we
>   	 * trapped to EL2 have completed. This also synchronises the
> -	 * above disabling of BRBE and SPE.
> +	 * above disabling of BRBE.
>   	 *
>   	 * See DDI0487I.a D8.1.5 "Out-of-context translation regimes",
>   	 * rule R_LFHQG and subsequent information statements.

