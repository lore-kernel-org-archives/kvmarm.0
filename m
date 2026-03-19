Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011067.outbound.protection.outlook.com [40.107.130.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A02E3B8BCA;
	Thu, 19 Mar 2026 10:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.67
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773916798; cv=fail; b=AejajEVOqEydBlyYWmDMJwSq97syrFYx+WacXHBPnZFFwkecZ/M3DGcmPlCIM6SPvA2s9B4sKhN9zLEyTAg4KwLjZnmuhRE5df69mljtYishjWaAxdeBRUyLBusGUt3lSjkeXfoXrowCozMZv+PDVqlnSSj135oaYsZkXR5xA9w=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773916798; c=relaxed/simple;
	bh=O+mj6cwGuDBN89pvrObMOza50jxh5bOs4AhwVnGVoJ8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PWXNWKZPCGF4IFPPneJ893Fc8W0PfMoroK3jrn0bzVPNiMHIPnNMFAgNoWsB+4ILM9UqVSvxQL21Kb7Ldq1vUAGZiDrK26RZoa/voqmGPKMSoi8O8ZidubLn32eyf+71wccD1KMi+kWKeQnipn7p0QZgc2AfSk2DDsVfCHSk2wY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LLVnd489; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LLVnd489; arc=fail smtp.client-ip=40.107.130.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LLVnd489";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LLVnd489"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=uCUaZ05+RLuQZ61fRe/u93KtIs3X9gjjL8N7s6eoUVp3nvmAjT85FaKQfbDy3lmip9tAJUFnGdJjz+AaUW82VijA+HF+omnrN1nyoWhxSOoRYriPTVMSn3/bFAnmwA6hEUg9ipUEhJZ/uR56bpzWqSlPm0Vvl3kWMskYI7TA2yHXsUGRHU05jueum+NSx2m2khhrDfGnCOdeM2Vh6Ma/gyTaSO51YqDOITzDJz/JKjq4WRFKVBlhiyR3o1pbfEVa/CoyYH+MD1/Ene6pkEfVPjP7xaoCWeW8Yyh1yn3FLCLYRUSpth9V8NTSBnobXmJPWH0HDoz3KnuWqMtHzqo+dw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qULoYgqgj1t3izZqynFL7xoH9raNabshwQgc2jc5T+g=;
 b=Fp6sWZSGqgR2syv2dzcxewOcNMFwo8yYan5t3orJZWjw9R9cF9v6pw4hsbpbYlCSR4mHcI503JbvqYgtASQHkTCXTzmAAya0lY9BGXANqOjMq138R9LUSEHArbLJzHDGpk1w3p4hXsxi/aosrs15m3kvnp8IzaS+ut7wKibOzjGHl8DrBx+U2LdyB39xAWkJcWvrahsd1hiYAQDin6RV0sQsQDy7eZDo9glHjgIy7IOPqJrPc7+qq9zkcJlEklGzdma85Mr8wcEHErmF36BMZSgbqP681spiqP4G65ts5h6MScFKCg+I57vHdRQSYVKCQ9Rzpmc2MGvdId61A5b0Kw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qULoYgqgj1t3izZqynFL7xoH9raNabshwQgc2jc5T+g=;
 b=LLVnd489TC/waWe2+7EMte7dJALUhIoyI9w/J4Ug0APy+b8Ecc9J152uBx9Xg1AP/rqzSI5Jaly3MQHZZzJG9HcvQ2NHIpgbjHlqIcMDX3c3Uv8dGjt6xmR231yLcrDOfU/AxZvBbgldPZtQ68HILb6BjBdxY34G6VwBRMR28Cc=
Received: from AM9P193CA0028.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::33)
 by DB9PR08MB6588.eurprd08.prod.outlook.com (2603:10a6:10:25a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Thu, 19 Mar
 2026 10:39:50 +0000
Received: from AMS1EPF00000044.eurprd04.prod.outlook.com
 (2603:10a6:20b:21e:cafe::42) by AM9P193CA0028.outlook.office365.com
 (2603:10a6:20b:21e::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.24 via Frontend Transport; Thu,
 19 Mar 2026 10:39:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000044.mail.protection.outlook.com (10.167.16.41) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 10:39:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bhANaffRSxJtHV4QImeE2PASiz26T0MaTGAuj/7KXRpN3tJ7nKX7ReKBYm9dFVQNHtEXuH5BpDWWonGPh1S0YG7upnxE19SdYnho5nQtwB5j8Xig7oyZb3vT8ANgyU8pys3Yv8tBM0G1LYRg514HoU0rcCaBaOlAn8Ko2lSN+pYYCDRCxOXNstGuAoacISwwJZUqS2gWKa0HnIXV/PHcJUyl4I37Sypcvi6xxUeJ20/b5cubVw9RBZYxrq7W8Ou+9ICGzUm2Yq1f7cJKnFltQ8VCox7XVQ9jo0bU9ZMaU7uz9bhwwQ7/OmPfZtOmahdittxRpNjm0kLFB/m3GSfAJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qULoYgqgj1t3izZqynFL7xoH9raNabshwQgc2jc5T+g=;
 b=WKlaP2mtg3IzjWA2uejU1PsP4p1G7WLyizA4laT+zFD7AHSC/wXo5n8iG1txpeSDC5FWfWc1MyAGkuNf1RcQAdHlYQjiFgEcSilD/YHWxxj9cD+WecRphYMgo5onaw5QRQxx/fPgU/qEW4/n1bSGIS1/bY6Y/DisLPDfTgu3QMsDhvv0gXDFVQ/LBU/2jpn0k6yKGtpVtPgLAaeqVnxmbDB8z9/KQ2e3LXBcXPgQZF5uj4H9DURRSzn2UtH2PIBQBTbwGO/mkMzKopYJNDyqXPF6NtUF1lXyPDJxIv8KRsQWsijdVwL7DJFEYWCXweyBSPjir5Oc3XtRVenP4QDApg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qULoYgqgj1t3izZqynFL7xoH9raNabshwQgc2jc5T+g=;
 b=LLVnd489TC/waWe2+7EMte7dJALUhIoyI9w/J4Ug0APy+b8Ecc9J152uBx9Xg1AP/rqzSI5Jaly3MQHZZzJG9HcvQ2NHIpgbjHlqIcMDX3c3Uv8dGjt6xmR231yLcrDOfU/AxZvBbgldPZtQ68HILb6BjBdxY34G6VwBRMR28Cc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by AS4PR08MB7604.eurprd08.prod.outlook.com (2603:10a6:20b:4ce::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 10:38:43 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%5]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 10:38:43 +0000
Message-ID: <8fd56e84-821a-47c7-8735-928057a7a653@arm.com>
Date: Thu, 19 Mar 2026 10:38:41 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 07/48] arm64: RMI: Check for RMI support at KVM init
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-8-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260318155413.793430-8-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0365.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:37c::18) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|AS4PR08MB7604:EE_|AMS1EPF00000044:EE_|DB9PR08MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: c6c2c38e-3998-4422-6669-08de85a3d874
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 JDg2UnVi+mY2Inyn498cRutx2UVp3gv6HyfPaDyolAbgVfweH+TMynYUhsNhGGEHOxmo8BNQOvGgH1Ycx1CADv5ofy71cNHYXHWQ+jMMnPK9GXMc/tsi2b6eoLs7jl5oRgtf+RiOVMMVDfdTTdg8fTHxX0phYlDudXmMDYmSGNHXTfkNoKfwxqdbYmcCLleQfud6/YVeS+kfb6sNWTZnDvhWKa2dTBiGHoY56l0uiDC0BgEILvGuCD2jcvINEmU9QgHCNBSfs7tJ9adWgWyahgXHwXWDIMhN7oeIkkZ7yDM8XgWl/1n+9kn2rIE32bKhiK4bzEKurQaj7yZvT0agPhqFvN+DuE4s4NA95JWz1HRQnra72uzykxQlXWH9xi3aSNkl+bD24xidQbE/1oWhro1an+oNR4DPQZ/PY0gRCWU8eOXRr1VCf67Fq8IZBPyxFpT/63aboDyl0xBNGZo0PMYEaX2Nor1CWRpwsWWZP6XACdWw7eVb0wPB6cLFvxwRXbBTuo12pZoOjsIePwbmb749R8iJGAreDf8tA9vTPteQhm3dbc4xsE99dMu8aEU8uPKiYZcZrgS02PmClVgYpvTqAYvAzH8n5crFdVZNw6EaauGcQ8IO4IcbENqqVkbLsOhcR4v6DSX/KJZ0tETkt8mzDDralGJbAnI+FW68HCFcYgdTEFa0Hv67Tnax8TdZk2ejJhHMFQ0z1AoTlYNPJuOEhJ2CWALhr523xX2QGe0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 gXGeZCnzj6vdHJkr5T7VsJqwU5rpRUackW+nUJKc1on4eiTPX4MTPSLtAF2NAiqF7AddUcOcBPF7Ooj3EP8LEgCRPQSGi0ZhSKt5JLCESQ6BR1PcRJe5JeB1YdH0+/cThZpVkys7n2iXC4/PsvAeMNIm3wBVjq++79ghRRKByvycv0NDmkyIZoxo4QoO2VRJcUIGyOWKlrcoNmx0c7xuzhyq8TrFWtTU67sLGZ/zMOK8aXj5pv8xHblc8MDgFIn6+KpdUeKmjYmGqktDAvEVLd5GvT3C2Kd2tEgsA1MsoGxHZg6j36A2/NkZRkODSDxrHgP/4azGcgJZeJy3lD+2WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7604
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000044.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	19d2fab1-5f5c-4618-6527-08de85a3b156
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|35042699022|7416014|1800799024|14060799003|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	gHPcFEEuZL0RTvL0e8L2GSDHR23ac2+zqs7k971axSnTcmTY3iSpeqGLKVoEQAFzaloGTfmv1E0XvY9fK90NNn9AvUBQvPG/8BbjYnjVH0WUm4Cwc6Kk1L6j3eErmkg8SQwccIZSpdJFB5bP56SPPN8WBuQElPLAZOaIBeJoBC/Rx1SpPSEZQAxp2uvY2bxoIbEfd83c9pjLIrq6eETZQp2/MiKXEttQPfaOgZT2ON5yWSMfFxWY7Wh/OjkL3MNhekl/lc0QqUoS/tAp8OPMNvC5x0MNxCgBlYwz7zBPlWOe6/MP+R2OjsWktOJkckYkzepCscPqmPps2tqYBfSa17quXO/+cN8lvieOhK975PYPD5I2E73K8i+MIQafdpYp3w/4C0x/roiDAnETXgFbGOnLxHIUlZlrBPmOr+0TfkCPU9iicrL3m3Yij6LfYbtVxioKWjBunRpySLJBUEW2qILoz/r1b/rL9LLOHRrn9cZ75IFXGIGD69v3j5j65mXGqCF+b2nE5x5bioPFH/TY3pBTYSeKIOUblgMaeVBMjCVQPG4AU/NGdZwCprtup72ro7wcpeX6Kfap2FpUduQJ+YJX1QRb4ty316D2DzgwRh7w8dt7dL36ZaQ3KkMtb8TVrwakQH5XDS5HquiT2YdjRnaGAX55uDbFSXLHUOSUV8/hcnhTvJtEzssjlFROl1oFVK6ZZy/nN0IGTegOZ6EwWkm32ak9BaLynIE1E0U3hgDO/FXeln6DzCybRvZcQIdyXdUwOA9bcc6RdShc4unR3Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(35042699022)(7416014)(1800799024)(14060799003)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	G8nKLErgRjVDrkYUX1gLsMZ4po5CkYq7p1Qn1eAnTvv1fHLxgFklke9o+l55VZmw2pxc9emM5cgtsbMBzl1GEihPhibORABNsE+/OhsFxh74GExdQsECk4WuWmjJYPx4MXxHw4JZlsAMvMfc/U3iU91UfJ6nL6MmHufTqtZdt/ooP4j0AvItoBSdocfUzXiLaCZqIUHggy93xwUAKM5FaamJbeszVwxJTAiTZVGOV4lqHm6y37u9Mc3YEWjGQHacpUOwNl7MPL4EYv7MFEoTEVBpbXOu4H94kkpBxKIc2wCCDN1/SIXWPse+SkeQK9I5IXjsu2QMo5CeTMrNhlJuSquy3MaBMn8//U/7qejbJ4zhySRd+IvhO/Fgp7vHwmLX3KQYIfZAzQGLmHUPitmLKo/bXDAji/0osmtNZTkNr0BGji3laTMEfMdYtRylsD8z
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 10:39:48.9820
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6c2c38e-3998-4422-6669-08de85a3d874
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000044.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6588

On 18/03/2026 15:53, Steven Price wrote:
> Query the RMI version number and check if it is a compatible version. A
> static key is also provided to signal that a supported RMM is available.
> 
> Functions are provided to query if a VM or VCPU is a realm (or rec)
> which currently will always return false.
> 
> Later patches make use of struct realm and the states as the ioctls
> interfaces are added to support realm and REC creation and destruction.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v12:
>   * Drop check for 4k page size.
> Changes since v11:
>   * Reword slightly the comments on the realm states.
> Changes since v10:
>   * kvm_is_realm() no longer has a NULL check.
>   * Rename from "rme" to "rmi" when referring to the RMM interface.
>   * Check for RME (hardware) support before probing for RMI support.
> Changes since v8:
>   * No need to guard kvm_init_rme() behind 'in_hyp_mode'.
> Changes since v6:
>   * Improved message for an unsupported RMI ABI version.
> Changes since v5:
>   * Reword "unsupported" message from "host supports" to "we want" to
>     clarify that 'we' are the 'host'.
> Changes since v2:
>   * Drop return value from kvm_init_rme(), it was always 0.
>   * Rely on the RMM return value to identify whether the RSI ABI is
>     compatible.
> ---
>   arch/arm64/include/asm/kvm_emulate.h | 18 +++++++++
>   arch/arm64/include/asm/kvm_host.h    |  4 ++
>   arch/arm64/include/asm/kvm_rmi.h     | 56 +++++++++++++++++++++++++++
>   arch/arm64/include/asm/virt.h        |  1 +
>   arch/arm64/kernel/cpufeature.c       |  1 +
>   arch/arm64/kvm/Makefile              |  2 +-
>   arch/arm64/kvm/arm.c                 |  5 +++
>   arch/arm64/kvm/rmi.c                 | 57 ++++++++++++++++++++++++++++
>   8 files changed, 143 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm64/include/asm/kvm_rmi.h
>   create mode 100644 arch/arm64/kvm/rmi.c
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 5bf3d7e1d92c..f38b50151ce8 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -688,4 +688,22 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
>   			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
>   	}
>   }


--8>---

> +
> +static inline bool kvm_is_realm(struct kvm *kvm)
> +{
> +	if (static_branch_unlikely(&kvm_rmi_is_available))
> +		return kvm->arch.is_realm;
> +	return false;
> +}
> +
> +static inline enum realm_state kvm_realm_state(struct kvm *kvm)
> +{
> +	return READ_ONCE(kvm->arch.realm.state);
> +}
> +
> +static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
> +{
> +	return false;
> +}
> +
>   #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 5d5a3bbdb95e..9267a2f2d65b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -27,6 +27,7 @@
>   #include <asm/fpsimd.h>
>   #include <asm/kvm.h>
>   #include <asm/kvm_asm.h>
> +#include <asm/kvm_rmi.h>
>   #include <asm/vncr_mapping.h>
>   
>   #define __KVM_HAVE_ARCH_INTC_INITIALIZED
> @@ -405,6 +406,9 @@ struct kvm_arch {
>   	 * the associated pKVM instance in the hypervisor.
>   	 */
>   	struct kvm_protected_vm pkvm;
> +
> +	bool is_realm;
> +	struct realm realm;
>   };
>   
>   struct kvm_vcpu_fault_info {
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> new file mode 100644
> index 000000000000..3506f50b05cd
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -0,0 +1,56 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023-2025 ARM Ltd.
> + */
> +
> +#ifndef __ASM_KVM_RMI_H
> +#define __ASM_KVM_RMI_H
> +
> +/**
> + * enum realm_state - State of a Realm
> + */
> +enum realm_state {
> +	/**
> +	 * @REALM_STATE_NONE:
> +	 *      Realm has not yet been created. rmi_realm_create() has not
> +	 *      yet been called.
> +	 */
> +	REALM_STATE_NONE,
> +	/**
> +	 * @REALM_STATE_NEW:
> +	 *      Realm is under construction, rmi_realm_create() has been
> +	 *      called, but it is not yet activated. Pages may be populated.
> +	 */
> +	REALM_STATE_NEW,
> +	/**
> +	 * @REALM_STATE_ACTIVE:
> +	 *      Realm has been created and is eligible for execution with
> +	 *      rmi_rec_enter(). Pages may no longer be populated with
> +	 *      rmi_data_create().
> +	 */
> +	REALM_STATE_ACTIVE,
> +	/**
> +	 * @REALM_STATE_DYING:
> +	 *      Realm is in the process of being destroyed or has already been
> +	 *      destroyed.
> +	 */
> +	REALM_STATE_DYING,
> +	/**
> +	 * @REALM_STATE_DEAD:
> +	 *      Realm has been destroyed.
> +	 */
> +	REALM_STATE_DEAD
> +};
> +
> +/**
> + * struct realm - Additional per VM data for a Realm
> + *
> + * @state: The lifetime state machine for the realm
> + */
> +struct realm {
> +	enum realm_state state;
> +};
> +


--8<---

Minor nit: The above looks out of place in this patch. Could we
move it to where this may be actually used ?

Rest looks good to me.


> +void kvm_init_rmi(void);
> +
> +#endif /* __ASM_KVM_RMI_H */
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index b51ab6840f9c..dc9b2899e0b2 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -87,6 +87,7 @@ void __hyp_reset_vectors(void);
>   bool is_kvm_arm_initialised(void);
>   
>   DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
> +DECLARE_STATIC_KEY_FALSE(kvm_rmi_is_available);
>   
>   static inline bool is_pkvm_initialized(void)
>   {
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index c31f8e17732a..ddf7e57f23e8 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -289,6 +289,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar3[] = {
>   static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
>   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV3_SHIFT, 4, 0),
>   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV2_SHIFT, 4, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_RME_SHIFT, 4, 0),
>   	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_DIT_SHIFT, 4, 0),
>   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_AMU_SHIFT, 4, 0),
>   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_MPAM_SHIFT, 4, 0),
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 3ebc0570345c..e17c4077d8e7 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -16,7 +16,7 @@ CFLAGS_handle_exit.o += -Wno-override-init
>   kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>   	 inject_fault.o va_layout.o handle_exit.o config.o \
>   	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
> -	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
> +	 vgic-sys-reg-v3.o fpsimd.o pkvm.o rmi.o \
>   	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o at.o \
>   	 vgic/vgic.o vgic/vgic-init.o \
>   	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 29f0326f7e00..274d7866efdc 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -39,6 +39,7 @@
>   #include <asm/kvm_nested.h>
>   #include <asm/kvm_pkvm.h>
>   #include <asm/kvm_ptrauth.h>
> +#include <asm/kvm_rmi.h>
>   #include <asm/sections.h>
>   #include <asm/stacktrace/nvhe.h>
>   
> @@ -104,6 +105,8 @@ long kvm_get_cap_for_kvm_ioctl(unsigned int ioctl, long *ext)
>   	return -EINVAL;
>   }
>   
> +DEFINE_STATIC_KEY_FALSE(kvm_rmi_is_available);
> +
>   DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
>   
>   DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_base);
> @@ -2921,6 +2924,8 @@ static __init int kvm_arm_init(void)
>   
>   	in_hyp_mode = is_kernel_in_hyp_mode();
>   
> +	kvm_init_rmi();
> +
>   	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
>   	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
>   		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> new file mode 100644
> index 000000000000..fac151580c01
> --- /dev/null
> +++ b/arch/arm64/kvm/rmi.c
> @@ -0,0 +1,57 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2023-2025 ARM Ltd.
> + */
> +
> +#include <linux/kvm_host.h>
> +
> +#include <asm/rmi_cmds.h>
> +#include <asm/virt.h>
> +
> +static int rmi_check_version(void)
> +{
> +	struct arm_smccc_res res;
> +	unsigned short version_major, version_minor;
> +	unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
> +						     RMI_ABI_MINOR_VERSION);
> +	unsigned long aa64pfr0 = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> +
> +	/* If RME isn't supported, then RMI can't be */
> +	if (cpuid_feature_extract_unsigned_field(aa64pfr0, ID_AA64PFR0_EL1_RME_SHIFT) == 0)
> +		return -ENXIO;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_VERSION, host_version, &res);
> +
> +	if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
> +		return -ENXIO;
> +
> +	version_major = RMI_ABI_VERSION_GET_MAJOR(res.a1);
> +	version_minor = RMI_ABI_VERSION_GET_MINOR(res.a1);
> +
> +	if (res.a0 != RMI_SUCCESS) {
> +		unsigned short high_version_major, high_version_minor;
> +
> +		high_version_major = RMI_ABI_VERSION_GET_MAJOR(res.a2);
> +		high_version_minor = RMI_ABI_VERSION_GET_MINOR(res.a2);
> +
> +		kvm_err("Unsupported RMI ABI (v%d.%d - v%d.%d) we want v%d.%d\n",
> +			version_major, version_minor,
> +			high_version_major, high_version_minor,
> +			RMI_ABI_MAJOR_VERSION,
> +			RMI_ABI_MINOR_VERSION);
> +		return -ENXIO;
> +	}
> +
> +	kvm_info("RMI ABI version %d.%d\n", version_major, version_minor);
> +
> +	return 0;
> +}
> +
> +void kvm_init_rmi(void)
> +{
> +	/* Continue without realm support if we can't agree on a version */
> +	if (rmi_check_version())
> +		return;
> +
> +	/* Future patch will enable static branch kvm_rmi_is_available */
> +}

