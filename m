Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012018.outbound.protection.outlook.com [52.101.66.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC89345CA3
	for <kvmarm@lists.linux.dev>; Fri, 31 Oct 2025 11:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761909137; cv=fail; b=RWPBzVCYsACcKZsOISS1GAWehV3jVPsvWl4Kb0Hj7VlyUc+o0uDk3A0axUYpRA9xUa/7UUWEOOLwgVh2SvnUF0Xl7uZHNlBrOcY9DCPU9xApMlWM3lgEjwgRqfz8amUjVf+7GhIbS/v+wrPxtUMCPFQrc6gW2z/vTWlnx2uxxeE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761909137; c=relaxed/simple;
	bh=lxshdVgiXaDth0ePQwRp69gJof/IDFMERdflJ4mrNdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=thL3ZSqIsibWYSg/ub/1YijiBAHi/8ZrsBoJdUu9ojQrcnhQxad8GSle3S3YfLBOHByLQoyj/r1+jjWlRpRIi31bVm+nKa14qt8wG0aOS0VLjUf3t9onOCher4vrm/dkfPSaW9bjanh5hiH5bYDOdmtcjbFwoU3f2/GYQov5ky4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oj8Z2gvH; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oj8Z2gvH; arc=fail smtp.client-ip=52.101.66.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oj8Z2gvH";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oj8Z2gvH"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=KCTGiyi0M6f3F9TXmrpWtsa7HZJAbxNQ8Y6+rTPFcPjJvRWyp33V/82Mmn6mTOsI6JYLRouo4kXMRlncSZyg0hq9z4jKFGxXh7KL4A1sRewdGrbvJp1HqKKkXnGe9XgCig8MYJ33v2ZdillAsIsTovZnIkm734JMscq0GlXF4TOTUU8dMCTPxLOv8Wa7XPLMUPlSnxJduwmikYIAXtx2WkocSxPa687L5TUMkT7fDcR7CyC2rASyzYBGIm7NkrrZxjgPflRpRV/Hv5pMICSIRp2JeRC+fNt22/bDDoc9urxaAxKenn4+E698qLnoiApsDgYuQMhG7x+HnWLaJ0XFsg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lxshdVgiXaDth0ePQwRp69gJof/IDFMERdflJ4mrNdQ=;
 b=rPor+PLToYI3NSS4dCgOUze84NvL+mY9CqmWsikamj6rOG5Ch5kHOsNTIUkSmOKMI51s/sjZiUx3l213a3690JpkKvWNs9fEGW40jPr8Il3LEqXrZkNpA4Z8qYWuK34HCwbr5OwZtvrP3L7MX19d6k1UIUCDJV47Gv0K/h2nHMhod//JviU+PayYzdCd/nPbiIBdwEoIckfZEL4tiRgOXEiF3PXjM3onXYsfVjdL4GtfgcTr+LSzLtnrG1eX+fxdAhHsNoY8stHL1eLkS17Ha90jdkSCGHI+qmjtZB9BoqJWU6RL9OgqINqLaeR8UEFzcYvPhU9RGAiiMZ+8sei+Rg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxshdVgiXaDth0ePQwRp69gJof/IDFMERdflJ4mrNdQ=;
 b=oj8Z2gvHlkWJanCvMfIxRmuyxG41jRe/64yLPUhYMt87RWuHaCDRzN9C6kPxo2yFv+BXA7labi0WR4ue/ihmupxCyyZh029nqQ3K2Arukn0yz0VIMvl9DJaVyRoOFMVeN2Lq8sB7wAr14zHXILWCCC5CVFqxghnks36vuXlLw0w=
Received: from DUZPR01CA0120.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bc::18) by VI1PR08MB10146.eurprd08.prod.outlook.com
 (2603:10a6:800:1cf::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Fri, 31 Oct
 2025 11:12:06 +0000
Received: from DU2PEPF00028D0F.eurprd03.prod.outlook.com
 (2603:10a6:10:4bc:cafe::3) by DUZPR01CA0120.outlook.office365.com
 (2603:10a6:10:4bc::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.15 via Frontend Transport; Fri,
 31 Oct 2025 11:12:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0F.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.10
 via Frontend Transport; Fri, 31 Oct 2025 11:12:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x5Io/EtKrCTAZOQN4mTpL9eH0ACwgEHIkuDKvCUH+UhBf14ScVrJuQTJ9VlhL7YxR2f4Vc5VLnRzDFHUZX3ZEk7SpKeKj2E8fLn3t2RwgocdjFya9UiRKFCnypByQm4lxGptHyuPlz1MNR+axX9uRvjFDh0LAshQSvFzTL/mGPzv0PW6TLRpZnyaIjRbO2HwM4LUemwLKIKIUfoge+Q1L+MVOzKLQ4x/Zm6M2pqW84cIpLqGMSlQzJMWg1q29+COaCS0PCmLh1EYKBInqvAFsdhr1C4qSNKV8VORssdhvjRGlPsZNDGoSDyBQvAX7VW0QpzmC2u2EyQHdGxCou32wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lxshdVgiXaDth0ePQwRp69gJof/IDFMERdflJ4mrNdQ=;
 b=ugvpPQoW/2u34wqh8/ImXAIG5BIXHOT8w/GmXsPPQrpXD6lmNDqRrrJDrObGJtelvkp2mw3xYLPhpifTg6Jlmn+dhVbyjHCACRvUzS5rHXUr1Ps8EilFSL03znM8miLogu+SWyQv9ljqaaLUz2WtS/mDkdWf/Tkw6uyZ3xkeeZSp/QhVUx0lY4kh7hsQlJH670NqziKKLUZHiCwO8apsRjMEuRV5EiVnlz/42Sth7YtRbuV7jRPOQy3jxBBg9Ma+YbgT0zVdFoFQdfhZ0VvizFfRIU1p3PZm17RF7akFOjtj/U7iGt7OX8GIL27823VL7gisJ+naGsGtxTFjxtzTEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxshdVgiXaDth0ePQwRp69gJof/IDFMERdflJ4mrNdQ=;
 b=oj8Z2gvHlkWJanCvMfIxRmuyxG41jRe/64yLPUhYMt87RWuHaCDRzN9C6kPxo2yFv+BXA7labi0WR4ue/ihmupxCyyZh029nqQ3K2Arukn0yz0VIMvl9DJaVyRoOFMVeN2Lq8sB7wAr14zHXILWCCC5CVFqxghnks36vuXlLw0w=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB9PR08MB8459.eurprd08.prod.outlook.com
 (2603:10a6:10:3d5::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Fri, 31 Oct
 2025 11:11:31 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 11:11:31 +0000
Date: Fri, 31 Oct 2025 11:11:28 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Sebastian Ene <sebastianene@google.com>, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, perlarsen@google.com,
	ayrton@google.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	sudeep.holla@arm.com
Subject: Re: [PATCH 1/2] KVM: arm64: fix FF-A call failure when ff-a driver
 is built-in
Message-ID: <aQSZYJQfcWCTtIZm@e129823.arm.com>
References: <20251027191729.1704744-1-yeoreum.yun@arm.com>
 <20251027191729.1704744-2-yeoreum.yun@arm.com>
 <aQRuvu8V3woqnqCV@google.com>
 <aQSKpZDrLzf/bcx7@e129823.arm.com>
 <86ms57v00j.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86ms57v00j.wl-maz@kernel.org>
X-ClientProxiedBy: LNXP265CA0003.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::15) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB9PR08MB8459:EE_|DU2PEPF00028D0F:EE_|VI1PR08MB10146:EE_
X-MS-Office365-Filtering-Correlation-Id: 32ecca20-a36d-40c3-9a7b-08de186e52db
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?UHhIWDdCcU9iMklLaVFseTlyZ3FOSkpZNkU4ZFg5VWYxUm8zRkZ5VkE2UVhr?=
 =?utf-8?B?ZnV6QVhGUDRRM21nUFAxd3lsNlAxMW9VOVo3Zno0M1BxYnI5d0lHV0lEV0p3?=
 =?utf-8?B?QUNvczlCSjZ2RzlnVnZEcmUxWkZxUTZ3R2VWL2M4bW5TbVMyY05LMkhraGNQ?=
 =?utf-8?B?R25rWXluYmlzSGZXWGxEZC9maXVxRE1BVDYybXhoTk0wcVl5Sk1vcnQ5YkxW?=
 =?utf-8?B?OHkvVkJLNnhWVUVVZURhdThzS0ZWRGtieGJwRUdWd1ZGMWlKODRBMGNRRG4r?=
 =?utf-8?B?b3UwMEhlQUQvRFRXdHRuSWxpanpPYjlldkorMzAyTjRwaWFLbW8wZTVRVy90?=
 =?utf-8?B?Njh3L3Z3ZVNMRlllaWtsTlkreDNaVTQ1Q2dkU0VOakE5WUIyd1RBYUtwYmNG?=
 =?utf-8?B?cmVBSzV5cUh3TW1QN2hDZGNPZTlSTTdqVnRQODZkeFgxaXRrTEU1UWVER01T?=
 =?utf-8?B?SVhpT0o4V256RE11eitIOVVpbnNHRDZ5c2NnSzJzdDB4REJYL2NXamJlWERn?=
 =?utf-8?B?VkdjTnVYSUFaYUV4ZFRHbzJNTTZ3ZGRuMHlPOG1FNFJKZDhMZnVsZXRiMVFs?=
 =?utf-8?B?RWx1QjhHQ3A3SnN2ZFljY3pETTZucS9wWTRld2JtZzVrUW1zeW5XL1phb0FP?=
 =?utf-8?B?bTFiN1BJUjRrekZleWN3R0xKcDU0ZGR3M2NIZGpXSHUrZmpsOHRYcCt4ajgw?=
 =?utf-8?B?UWxOWGNwb2xpbmFnWUpjNmVZTUdOSGxIaFRlMjNLU3JXbWlMSFhaUmUwVFRN?=
 =?utf-8?B?VStUQlN3MnE4TkNleXFJUmhpZUdEOWg5cy9iejhxcEY2bldvQVB0bC9KNEtn?=
 =?utf-8?B?ZXdFMVVQbUxjd3VjSVRrYTc2NlkxcmQ3UVRyUnVGaVFBc3RhTEdwOGFWckxo?=
 =?utf-8?B?cVg1MC9aNzdhV3N0ODJSdUJaMXQ2bVgvRzUxd1h6b2drQTdhTVQwWk1iZC8w?=
 =?utf-8?B?Q3EwNlAxWHRpb1QyR3NoUkYxblVzQTZsWmhkRkFpZU1Bcis3NGRIOTFuMEcw?=
 =?utf-8?B?TSszMERlNzFTdEtJT2JaTUY1SFhzdWpXanZlSjZ2b04xaUZFTXRNeDBuU0dh?=
 =?utf-8?B?QmhBTmZycGRCaEpqZVFUM1UyQlpZU0U2UkJmMkhpYWIwcUtBcVlENVlzYWtJ?=
 =?utf-8?B?M0JFbVNHeElPUU9NdFUzWjNpWUJEdmZwdjIvdk5wNjM0RmVpOWlVNFlVd1JG?=
 =?utf-8?B?RjQ3RTk2eVdXWjJ1QzkvaG1ad2x4cDJNZURTc2JOemFzUUFaRC9jNk51eitD?=
 =?utf-8?B?cFFtWnQwanlrUUs2Wlk3L0N3NnNiWW5BbXJhMVVJOHpwMDJLTWhRQm5pQThy?=
 =?utf-8?B?OWMwZDIrTXVEaExqbjdRM3NwYklBaGcvTXZKbHpTQXdpcTJUazV4VzZuelRI?=
 =?utf-8?B?MTRIeCtsYUdRQUNPMWZ5Slp5T0hoYVo5WWhpR0FIcmNSTWo1UmZpUXdMK3dK?=
 =?utf-8?B?QVpSWm40MXpRakxBbXBrbm5ibS9zTnhORisxeFRFQWhEQ0tOTkpkRjZ6Qm85?=
 =?utf-8?B?TUZIVE96RHR5Ty9EWXFpSFdEdk81Yi9pSnFuYkFKNzFxUzAyUm5IYWJESzJv?=
 =?utf-8?B?QzRXWHVkOFRIdnpuQXp4WENJckNpcm04czVYaVExNGtiT3EvUllRbE1TZ0w1?=
 =?utf-8?B?NUc4R0ZNUmZ0a1pxR2dQL2FzNXFQNmJyM25iVVh5R0ZTNElacWJaUW1wVk5H?=
 =?utf-8?B?OVp5bGg3R3dCbitqKzFnMVgyQWJTZUFKbWVtMXZ4dGUva05QMnVyK1RYamln?=
 =?utf-8?B?WS9DZG0xT3NMK05IVFpvbDJLRS84cUwxRXZucGRyMWtWSGhaS2lidDVsOEkw?=
 =?utf-8?B?RzIvWkJHeGlsK1FHQm82ZnlwN3ZWZzBkdXJkdXArV1F6eUNVZUc1RURTTUE2?=
 =?utf-8?B?SDRoVmNpQ2ZhUWE4Vm5idjdpdFpCT25hc2N0TGNQUloralVIbkhMMVFHc1da?=
 =?utf-8?B?NlVSdUQ4QUYyK2lGVCtjQi92a1Y3QU5tWFJ3QXpXb0hYY2dNRWJDRG1JNXV1?=
 =?utf-8?B?V0c1Ni84eGJBPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8459
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0F.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	aa5dfaf6-3106-49a1-edb0-08de186e3e92
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|35042699022|14060799003|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cVhIYXF3UmdNUnFaL0g0RTU5dDNNRWltcE1IQjFQT3FtR2VFSktYdDJ3cXlk?=
 =?utf-8?B?WFVScEdiSytrYXFEeGlMK1VubHVFWk1iOXF0T29SV1cwYkwzSHZxSXR5Z3BY?=
 =?utf-8?B?SVNyK3pkdEgyVFc5Um9mS0FXVXdvNWVTVzBGd3NRaS9QVWxFaE1QOUhLeWRy?=
 =?utf-8?B?ZEJIUm9CREVUQmtwRFl6dnRIcUF1dm13SHR6YmFSWkZMaWl0dkM4ZmRDSWpx?=
 =?utf-8?B?bEg1VWhLVklzYUZCUUVSVFhYZ2lrc0RJcFBUVUZYcVIrZWpFbUVMMlY4M29n?=
 =?utf-8?B?L0l5SHc1Q3lYajgxU3daM2VDenFLQTcwek5PZHVPWCt0L1IzS0JZU0JFN2pj?=
 =?utf-8?B?S1VncURlRndna1R4WmZCY0p5dnZNTWc2aWtJZGVXaFZhdGZGSytYU3JiRXZ4?=
 =?utf-8?B?R1BJQUtwZXhuNUNyckoyNEdLS0hTSTFudlhoNVdsTjNzTEoyZ0ZwT3oxZEhq?=
 =?utf-8?B?a0c2NGJPWUdQZFVjWGhRUFpCZmN5OEk4bFpxZTN0MTZoeFRiV2p3bStON2Nn?=
 =?utf-8?B?QzhJY1plZFZ5TU9XNXJKYWozNXNUdERobnpQT05EdVNQcDB0UnNlTjRIdzVo?=
 =?utf-8?B?NmhrcGsvcGRwTGJ5bG5wN2ZaVVVzcEFlRUpyTHgrR2RyWG5XVjFuem96dkVZ?=
 =?utf-8?B?NHU5ci9IYmF0NzV1WmxyZXpvV2k2blhmbDdkMkM3VDF3aTVkNDNFR1JjL2hV?=
 =?utf-8?B?VFZpWEhRVVJobEJLOE45OXpQSGRKdTk4SnpOV3lBMlQyelMrRzZiYWdHbFZi?=
 =?utf-8?B?ejVtNmtaTFZUSVpSb1FmSXk4NkI1VTdtSVQ2TGM3S1QrbFRIYy9ueExONHdH?=
 =?utf-8?B?WWZXUEp5TzNOZEJwM25jUkJRNHNjemRlNWUwL1dMbTRodml2MTdVQVVPZGxi?=
 =?utf-8?B?Y1p5ZkJidDIyQytDNUxoOWdQY1lPeXZHYlBuRkJoVXo3L01KQk14VHUrZ0M0?=
 =?utf-8?B?eDFKdW9mSDE3N1oyY3FJbCtlL2RKbkppYTFSd3BqTHduWXdwMG1PVnQzSHEw?=
 =?utf-8?B?N3pSYjI0T3hpYzYvZkFjcStmMCtqVjB0SWxnS0JpWXNRRjNWVGJGL3lzeHBF?=
 =?utf-8?B?WExzNUc5RHJtTnZnWkNoMkcvMUVGa2NOZ293RDR1QmZhOEo0Vm54cmlWT3lL?=
 =?utf-8?B?VlgwWUlrOW5pZFlRcGtYeUdESzlpY1E0NU50SklZa0hvakhxRFZscStGaXFB?=
 =?utf-8?B?LzN1VkV0aVpvVm9jalVCNzNGSkRHazFHTnViSk0yY3crUDhWRXdqUkVnYXBm?=
 =?utf-8?B?N0VBRkVUUHJQMVVRcUUwTVAyY0VJQ0hGK2RaVjl1OVdnK012VkNGSGdKb3pn?=
 =?utf-8?B?d3Q5TEh5dUZiN1BsMFhNaFdUSFZCc2pJVW1iZGZMR2puMDVrbVZmc1NvMkl6?=
 =?utf-8?B?WmpzZ0NobE11VkgzdkQ0MlgvaVVIR1JIS0RFQlBqYklqUlYwSUNGL3ZJaUlO?=
 =?utf-8?B?U0s0bGdYUERrUDRzbjU0V2ZOZE41Ky9iSTA1Yk4zMmM4S0k2UkZKNGk1M1Qy?=
 =?utf-8?B?d2lKY2FMSjBuekp3cDViRlBBYWpScnRoVnAzQkVjTGRGNjRBZUlCWkR3VXlO?=
 =?utf-8?B?NEYrOThWaTlOeHJtMU5yUzBaVGFHazBWQWFCV3E0d2luQnZPdjhlSXpNOWxX?=
 =?utf-8?B?MFlxR3BsN3Z3cm04VGN5WnEyUnlBd0VXUkFJekQyeUN4NTZXM1F4VkRCRXZm?=
 =?utf-8?B?Wnc2bDcyWTArbUNNSE5RUk04Y2VFQm5sV3JvaUtNM21TTGIxN21zQnI0Ulhi?=
 =?utf-8?B?RmZ6a2ZaSW8wSzFhbnpnRDVtNHVOaWVTSTl6cGxsUThjaDE3WE14TlJONThB?=
 =?utf-8?B?TXl3dXZnRnVhN2w3TWZRSWI5RTJkenp5OGFpNUFyMVhYZnFLa2ZkYm9ad3F6?=
 =?utf-8?B?SHFlNU9WVTJjTXVmMjh3NzR6ZytWcEdFM3JPVHAyUDZLTFptTElNaU9tblNx?=
 =?utf-8?B?RXRTRXpDM0RyK2RzNVRKTUpJREZZQTdzUkR1TEZNWGhCZE03Z1dZVWJtU0Zn?=
 =?utf-8?B?cEtlbzZ6RzNLWlJFWnpSMmZWeXFrVXNTMUs3T1d3WGY1N1BEVDg3VEV2QTUw?=
 =?utf-8?B?RGs3SXE1Y3VsREhQd240dndYSnorSlZ1YS8xZUh3cjNEVVFnRUFwVEw1VjZC?=
 =?utf-8?Q?Ap78=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(35042699022)(14060799003)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 11:12:04.7775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32ecca20-a36d-40c3-9a7b-08de186e52db
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0F.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10146

+Sudeep holla

Hi Marc,

> Yeoreum Yun <yeoreum.yun@arm.com> wrote:
> >
> > Hi Sebastian,
> >
> > > > Until has_version_negotiated is set to true,
> > > > all FF-A function calls fail except FFA_VERSION.
> > > > The has_version_negotiated flag is set to true when
> > > > the first FFA_VERSION call is made after init_hyp_mode().
> > > >
> > > > This works fine when the FF-A driver is built as a module,
> > > > since ffa_init() is invoked after kvm_arm_init(), allowing do_ffa_version()
> > > > to set has_version_negotiated to true.
> > > >
> > > > However, when the FF-A driver is built-in (CONFIG_ARM_FFA_TRANSPORT=y),
> > > > all FF-A calls fail. This happens because ffa_init() runs before
> > > > kvm_arm_init() — the init level of ffa_init() is rootfs_initcall.
> > > > As a result, the hypervisor cannot set has_version_negotiated,
> > > > since the FFA_VERSION call made in ffa_init() does not trap to the hypervisor
> > > > (HCR_EL2.TSC is cleared before kvm_arm_init()).
> > > >
> > >
> > > I understand the reason behind the patch but this is problematic to have
> > > the builtin driver load before pKVM because the hypervisor would be
> > > un-aware of the host mapped buffers. (eg. the call from ffa_rxtx_map is
> > > not trapped because it is too early). Essentially, you will end up
> > > bypassing the hyp FF-A proxy which I think you will want to avoid.
> >
> > Ah. I've overlooed the ffa_rxtx_map proxy.
> > But unfortunately, some of depndency with the driver using arm_ffa
> > driver, ffa_init() should be called first then other drivers' initcall
> > (usually, these kind of driver defines its one initcall with
> > device_initcall()) (i.e) https://lore.kernel.org/all/20250618102302.2379029-1-yeoreum.yun@arm.com/.
> >
> > Though I arm_ffa driver provide an API getting mapped rx/tx buffer,
> > But this seems to reverse dependency -- kvm depends on arm_ffa driver.
>
> No it doesn't. KVM doesn't give a damn about the kernel FFA driver. It
> just makes sure that the driver doesn't do anything stupid.
>
> > I’ve been thinking about some possible solutions,
> > but in my narrow idea, valid solution is kvm_arm_init() as
> > subsys_initcall_sync() and call kvm_init() in module_init() like
> > attached modification.
> >
> > Do you have any idea?
>
> There is no way we can accept such a change. It makes something
> fragile even more brittle. If anything, make the FFA driver check for
> KVM being initialised, and make the probing defer if not.

The problematic situation is that we couldn't use "defer probe".
For example, IMA doesn't support the module build
and if ffa driver and related drivers using ffa driver defered,
IMA couldn't generated "boot aggregate log" which should be produced
at that time with PCR values in the TPM using CRB over FF-A.

Whatever monitoring KVM being intitialised, unless "defer probe" makes
a problematic situation, I think it seems meaningless.

@Sudeep. What do you think about it?


--
Sincerely,
Yeoreum Yun
