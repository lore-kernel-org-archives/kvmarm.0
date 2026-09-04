Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010062.outbound.protection.outlook.com [52.101.69.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D3147606E
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.62
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522101; cv=fail; b=EqCzC3h0l4vDge12lmlJhWScofOXHX+QIb6VPMiA+ID8x/eG2w59xixQePQjskg7huBfo8XojU2S7kL5aFwlWWhIdo3CGlcGcRi+i8dsxqrB2fwQm5pXxa0XQ4F61hdAK3ru3VryAc1/Nt5lUzLQXb7ubodU27mF2aN0ebjciwo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522101; c=relaxed/simple;
	bh=34x308HXD06KmC6tWWxk2QuyM8/bAVx3P8f2RtKGlI4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n7sjPs9wza/Y5YwupAYI7emNux8EM/aerSfqZlYq8gXefl1OmvAdBDsmazrZ63KVKvozOxPtnPHRZtY/r7THk8kE8SXlhKXTXWlZLRb/ESzTOV0j9N14z2H/L6NiAwlDNAO0WQjrnAtYqVkouUw7bSmGWwVPDOIdRrsMjfaFKp8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dJn9CmqE; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dJn9CmqE; arc=fail smtp.client-ip=52.101.69.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dJn9CmqE";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dJn9CmqE"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lEpeli7V4cCjhvgeE9RxBAActuUVX29XkT6k7ftN/XR69PtAUw4xHLnfFsqT9XmASIIppshLE0LSE4MJ6PRCV0pk+C57Bus4+Ams3yZ7w1/tArdxSrujLWJe0OU2Sc1zPxCm/isJiueO+DuJMKNHLf+M+sXBsImtvoXoAZAR9WsV4PXokWiDFKdo6pj/mW/nyjfXz59pDAq153e8ajGcOLt1UtfmxpbowMZ3w52soBUP1PfnxfuqrbMT3WBSHo3W6MEqQfbh8Pi0w0uvZss+wsq4AjsJNe+iWVtUolrBQyXS3V+oaqBqtIOyoQaMc6B1GftsKjZn6cCmiPgddAORfw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VQINUiEIBmxWm4jUjj2x1mv0YkR8MOhXHW5nUWYE+pM=;
 b=TQmyDkCX9SikMlhPtKzQvkB8+tr81ui+OmS/pH2geWpV8tbjhgvYxnwniDBkSOCxvNAMuN5YSqJ3FPjL5LDfbpeXN2VfrU3p3pmnDficVXFP11vPp90G3GhC1jxd6lB0DMriwM9JW3qquaGOCqho4Lpho/tWAJEtbtKo1fOvwatXmTYlDp/SWPtE2UZXKK5wBHplscWz0Wmui3uO9jl6IpRkah0cOWJgWVB9hclWmqhPLoUCbRFQkUbwXWa1ubGDlDPmjbTVwsViTPLyMyihNP9nrI8C/eqEfl1luCEKaruObztnZQFejER4HPVyhraM8a6MiqhzYSi7TGo0FgsBwA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQINUiEIBmxWm4jUjj2x1mv0YkR8MOhXHW5nUWYE+pM=;
 b=dJn9CmqEnqVgWWe1YKcgnsajId62jBSFaVNgLIFEXOZREKW2c7kN06iEG49rP3xhg4FqXME/lqdGkBhSlXbMo9GE6w4JrWzNSBNnIw62UtoVz1TLY3aZIH2dBZ5NcYCLj2B/0DsOvpVD4CFap9Uq9rpdFCPhlVdIzUgf+DLyw74=
Received: from VIXP296CA0005.AUTP296.PROD.OUTLOOK.COM (2603:10a6:800:2a9::9)
 by AS2PR08MB9023.eurprd08.prod.outlook.com (2603:10a6:20b:5ff::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:41:29 +0000
Received: from ZR1PEPF0000E464.eurprd04.prod.outlook.com
 (2603:10a6:800:2a9:cafe::ab) by VIXP296CA0005.outlook.office365.com
 (2603:10a6:800:2a9::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:41:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 ZR1PEPF0000E464.mail.protection.outlook.com (10.167.241.57) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:41:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wIQbL6kMhrOxDjx58PcxBKn+ly8MmXjYsX4O15yhAjbyqih/nZg60cCnV9sB1EEO+NUQs2CuZeSlSiGc/ejkMOpDMXCXWj1x0jlIjSmhs0GV5pa2P6UD9rjMWRVOgcXRYTJlB0QZeWhYVWFLNgVD+d7FEQAlNrrJ7bhAgVLsBPuksIcwg/y8V76ULmoKG2fojlFITQ7nS8dB3Wz1dkfFW1cu19VceV8N0ldFnzDLnQUNjX5IGmFi7HYLVw3ZWA1G0s0zoRyeISJLQaHIlYHM0A07NB5msjURp4IYX3Uo/PMLlCyPuMnIb6MgyGiV1wFL6YzUbKFJRjbJazHo6dRoBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VQINUiEIBmxWm4jUjj2x1mv0YkR8MOhXHW5nUWYE+pM=;
 b=EyJp1/XqxyV+AUo1ujtwo6h8EeDBVTLRCRoF1DIZtPR/Z5AUWm4oXefY6neA5QLFuRleF0HfmtlIWEE2zRYhm0HsxFVPh7RQ3s0/ouw65aRWUVVW/srEMOXL7eWUs/LuKq12YCMucQ32Haa34FCVI2dhYTQyuMX4NoAqU1VsoMQrBrx23TcBl2bSBuPNu7wMGshUjwRwicTbIIh0ISYArwl/nhOSKQZY/g0WVa/0f1vDzJbPBLwvHXoGIqbixDyKQqr75gIGgcZ7sJlk0WyIEPSdBCRC7ooi2ROtA80C/cyt6uE/BxCjmQ4m/8OTGZkvH5B75Bgsi7Y3RZBWSLD1QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQINUiEIBmxWm4jUjj2x1mv0YkR8MOhXHW5nUWYE+pM=;
 b=dJn9CmqEnqVgWWe1YKcgnsajId62jBSFaVNgLIFEXOZREKW2c7kN06iEG49rP3xhg4FqXME/lqdGkBhSlXbMo9GE6w4JrWzNSBNnIw62UtoVz1TLY3aZIH2dBZ5NcYCLj2B/0DsOvpVD4CFap9Uq9rpdFCPhlVdIzUgf+DLyw74=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by GVXPR08MB10864.eurprd08.prod.outlook.com (2603:10a6:150:154::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:40:53 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:40:53 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v6 13/49] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Thread-Topic: [PATCH v6 13/49] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Thread-Index: AQHdPGI9jrxj1THEDk6rPk28ILpv4w==
Date: Fri, 4 Sep 2026 11:40:53 +0000
Message-ID: <20260904113404.4051341-14-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|GVXPR08MB10864:EE_|ZR1PEPF0000E464:EE_|AS2PR08MB9023:EE_
X-MS-Office365-Filtering-Correlation-Id: f0c574fa-2bd9-477d-7763-08df0a7974c0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|6133799003|10067099003|3023799007|11063799006|22082099003|56012099006|38070700021|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 xEqP73eAGh+tkNRDQnI7ZB5ulGwlhY5YR+fowvnlRmdieslOvOFlmqgCwWbpbH/R9zhZ5OIRMSrtzAeOYnb63ejmkqqtBFOs6D7Z+jTYTo9lhOVBQ/u7qKQ4Y42uSjaoqGfWZvwPrGRbh1AlFx5tV2T5WA9i82EwcyNi/pC0p3b/6Mm9WCX7qHHDZ6awgJpPEdrYl7PXDXWeBBiUmgju1BDCBdkCjdkjCdclg67zl5D7/cFiaOJ3FO7Mnmqh2PqCgHbXKacQSONEziX9+taqSeN1jh50D5s4glRz37MZEtPslU+b9Z+mmg9E7+wXBnD7a8GaNMQkOG6/3FqZvejEjUGpZus/Iqk3pEKD000pfNgqFWtqLPvJ/Gs9uDY12V13vyUGCjYyTZgDhBgCzxldAxow2roOwOmM7nF//Z6oHFEpPAMDvL4ajZO9mOY7DsgOFzs95vjMNdfQdKy2ua69uoaJzXRQVVXtrUBN1B8tmiwNYkeiRhYcNdbUf8+1aZuZx3x7UkzJL8gn/i85xNJrB9il4OXc/dUpu+U2yFCQzDQpHeooqdGZuM27+YNms/llMmMY7yxf/CS2AYvO0/Ne+AvFicYKVstKZ42BhsWTO8pwsyph0rf7opMunMFa9zM2MHQBrSoU6ePMEe9fggX0Fb+R0dxX6DHh90y2BCAIvl6b6NOMmDfeuKvc/YVyr+9FwQr+KHwhByBejyTnGkWR6ZKDZv812A4m65wjsQNMFYw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(3023799007)(11063799006)(22082099003)(56012099006)(38070700021)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 JeI8CtHQABh6nav+DX1QS5UWQBTHIULxXdfKrIZHBUhyDYr17e4jMFdE7wga85c9zzNg6KMckZvDTOl/nR94tMl42KDOPWaDgnZipi3eMigX/Ztut5jmka6JXOmQY3fXL4Jgx25CcND2OE0RbhX67VKsrEtt0lw0Q8AcGS9H/JK1ioMNu7hF4GrDEw6/ICskpT90v+eUkF0yD25EQBxJDoeTJkmsUL/sO6wK90ZAxNGMebRJ26BP9hj2xhen49nY9gC+jX298A1FMC53sgLv8KQhAdt979RiciALEBnKSGhoQLvPsH2RZoYx9xj4/eFp8FoT2Cgjg7x7iBb8eJcS0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10864
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 ZR1PEPF0000E464.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	51068bb3-6ce6-4cb2-d028-08df0a796048
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|36860700016|82310400026|1800799024|14060799003|23010399003|10067099003|56012099006|11063799006|3023799007|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	0fUtyAQYAKNqOM3gcrFD50DtLAWb1C2KHZ5v9gk4eFRG7Jwdesz3IxprYKuE4eB0E4fN03TxuCQOuKsX/DXtrg98ilp8qdZOUjx1D/oyU4atdQePwaAb9nh5nRLjIM6Wx+jGFaYlc6d1hokCNzbwOui7mAGsghKpF7B7J6z6BPEldIOHuyfWrpIQ7rz4JaAnkVttr3EeU7AMp3QPQvuO6PcJoHjKxGNxhI0Yoxd7N+DgApI8YIJ4vu/UJOWdj2FjjXD6FNwrHN2zZ7WaAWXqA8II+2y/PP86GG54IONGY6hJmKLfBiaxeq4wQBAAI8tMJCsCpi8acVkd1IayL2YkY86kbKDRx2rRGiY76/RgCWqdMUL5deOHJyGUNwXEziKBYsUldUFZmFntalPXWhOHYHX1UcBcuZt4Ikp8U8F8mvyiYE+BI4hxARbvUzNhETJwG1QpxtA9fDFxBi/1YjxFsLFrOA97tTAVO0pXyfcOQGAh82gQ0vI2oSVeQ5ly85q6+K/dmXsAoC7QrSXewM25ei+f2c8Nvdf7iqusWUpGcDBXL4dVNnxEjQi56LQFr6mJl3bKbgTtAMJArIYxSGPC6XTaNnZL+/j/vB33Q43Sog4FzieBsFcf9Hxy5GAxGo5K4eXHVvTTFI6mw96g6hnliXrZx6sYfod8XyT5+NuLH58=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(36860700016)(82310400026)(1800799024)(14060799003)(23010399003)(10067099003)(56012099006)(11063799006)(3023799007)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7KkP8YvZQ1Ng+Kmv0MT4BEQAyNepoismvatOhwE4fKIvLpyOFmb+6bz/BxmJEQry1UjuZF6mSRx+4cMymowuN6O97bbl2677GoOYCQcJKZqjsJ0EYaCfk/JkZMM1QK8gj5ZtEwsnMoDMLMLqPmte9pPvFtVD8WoxMe3OflzjvvbpxlAgboZpCQ+7wAl6rw4wO8cnVsA1mE+6uxa8EiEUACmmCKhMywGn85+0MhssL2u2tJAJxRcjMTWmiXmA8YoyYjLaGl9LQ16YUjCcnGuFACft+oX81rDjj8XkZIS9pzflvMe6SKcsLRkUv6zFJ0O5Kv0sAffmNO586dnDmPLdyk3yG7IiSCoksMKZ+5ab10BgaVJrSTerSKl23K3ygaqbl3a+JN7PLkCT0Vxpm+8b65wlhBlBKvtC0FDuh6i/xnlJ08sdgrmD5/Ow8UhzQf3V
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:41:27.4205
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0c574fa-2bd9-477d-7763-08df0a7974c0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	ZR1PEPF0000E464.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9023

Introduce interfaces to make VPEs valid, and to configure them, via
the host's IRS. As with the other valid bits in the GICv5 VM tables,
VPEs cannot be made valid directly, and instead are made valid via an
IRS MMIO Op.

Additionally, some of the VPE configuration takes place via the IRS
MMIO interface too (via the IRS_VPE_CR0, IRS_VPE_DBR). VPE doorbells
are, for example, configured via this interface.

The existing VPE-doorbell-based commands are extended with:

        VPE_MAKE_VALID - Make the VPE valid in the VPET

Note: There is no VPE_MAKE_INVALID as VPEs are only made invalid on
teardown, at which point the whole VMTE is marked as invalid. Hence,
it is not required.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c      | 84 ++++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v5.h |  1 +
 2 files changed, 85 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index e1571d1788a60..455161e52f81b 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -201,6 +201,18 @@ static int vgic_v5_irs_wait_for_vm_op(void)
 					NULL);
 }
=20
+/*
+ * Wait for completion of a change in any of IRS_VPE_SELR, IRS_VPE_DBR,
+ * IRS_VPE_CR0.
+ */
+static int vgic_v5_irs_wait_for_vpe_op(void)
+{
+	return gicv5_wait_for_op_atomic(irs_caps.irs_base,
+					GICV5_IRS_VPE_STATUSR,
+					GICV5_IRS_VPE_STATUSR_IDLE,
+					NULL);
+}
+
 static int vgic_v5_irs_write_vm_mmio_reg(u64 val, u32 offset)
 {
 	int ret;
@@ -308,10 +320,73 @@ static int vgic_v5_irs_set_vist_invalid(u16 vm_id, bo=
ol spi_ist)
 	return __vgic_v5_irs_update_vist_validity(vm_id, spi_ist, true);
 }
=20
+static int vgic_v5_irs_set_up_vpe(u16 vm_id, u16 vpe_id,
+				  irq_hw_number_t db_hwirq)
+{
+	u64 vmap_vper, dbr, selr;
+	u32 statusr, cr0;
+	int ret;
+
+	lockdep_assert_held(&vgic_v5_irs_lock);
+
+	/* Make sure that we are idle to begin with */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	/* Mark the VPE as valid */
+	vmap_vper =3D FIELD_PREP(GICV5_IRS_VMAP_VPER_VPE_ID, vpe_id) |
+		    FIELD_PREP(GICV5_IRS_VMAP_VPER_VM_ID, vm_id) |
+		    GICV5_IRS_VMAP_VPER_M;
+	irs_writeq_relaxed(vmap_vper, GICV5_IRS_VMAP_VPER);
+
+	/* Wait for the VPE to be marked valid in the VPET */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	selr =3D FIELD_PREP(GICV5_IRS_VPE_SELR_VPE_ID, vpe_id) |
+	       FIELD_PREP(GICV5_IRS_VPE_SELR_VM_ID, vm_id) |
+	       GICV5_IRS_VPE_SELR_S;
+	irs_writeq_relaxed(selr, GICV5_IRS_VPE_SELR);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	statusr =3D irs_readl_relaxed(GICV5_IRS_VPE_STATUSR);
+	if (!FIELD_GET(GICV5_IRS_VPE_STATUSR_V, statusr))
+		return -EINVAL;
+
+	/* Set targeted only routing (disable 1ofN vPE selection) */
+	cr0 =3D GICV5_IRS_VPE_CR0_DPS;
+	irs_writel_relaxed(cr0, GICV5_IRS_VPE_CR0);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	/*
+	 * The VPE has not yet run. Therefore, make sure that all interrupts
+	 * will generate a doorbell.
+	 */
+	dbr =3D FIELD_PREP(GICV5_IRS_VPE_DBR_INTID, db_hwirq) |
+	      GICV5_IRS_VPE_DBR_DBV;
+	irs_writeq_relaxed(dbr, GICV5_IRS_VPE_DBR);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
 {
 	struct vgic_v5_vm *vm =3D data->domain->host_data;
 	enum gicv5_vcpu_cmd *cmd =3D vcpu_info;
+	/* Our VPE ID is the index within the doorbell domain */
+	u16 vpe_id =3D data->hwirq;
=20
 	guard(raw_spinlock_irqsave)(&vgic_v5_irs_lock);
=20
@@ -322,6 +397,15 @@ static int vgic_v5_db_set_vcpu_affinity(struct irq_dat=
a *data, void *vcpu_info)
 		return vgic_v5_irs_set_vm_valid(vm->vm_id);
 	case VMTE_MAKE_INVALID:
 		return vgic_v5_irs_set_vm_invalid(vm->vm_id);
+	case VPE_MAKE_VALID:
+		/*
+		 * We need the actual LPI ID which lives in the top-most parent
+		 * domain. This hwirq won't include the type (LPI) but that's
+		 * not required for the IRS_VPE_DBR.
+		 */
+		while (data->parent_data)
+			data =3D data->parent_data;
+		return vgic_v5_irs_set_up_vpe(vm->vm_id, vpe_id, data->hwirq);
 	case SPI_VIST_MAKE_VALID:
 		return vgic_v5_irs_set_vist_valid(vm->vm_id, true);
 	case LPI_VIST_MAKE_VALID:
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 24949b6045311..299e75bc95255 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -661,6 +661,7 @@ enum gicv5_vcpu_cmd {
 	VMT_L2_MAP,		/* Map in a L2 VMT - *may* happen on VM init */
 	VMTE_MAKE_VALID,	/* Make the VMTE valid */
 	VMTE_MAKE_INVALID,	/* Make the VMTE (et al.) invalid */
+	VPE_MAKE_VALID,		/* No corresponding invalid */
 	SPI_VIST_MAKE_VALID,	/* No corresponding invalid */
 	LPI_VIST_MAKE_VALID,	/* Triggered by a guest */
 	LPI_VIST_MAKE_INVALID,	/* Triggered by a guest */
--=20
2.34.1
