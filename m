Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010064.outbound.protection.outlook.com [52.101.69.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17053C1969;
	Thu, 19 Mar 2026 10:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.64
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773916993; cv=fail; b=YojOo3HtY4avTTDhixMl5uDry8JCrUgYQcqKa9FlD364eWIO7DZF2CvrUOJdRDN2psFqUWsW1KIK842KPq35aoWmpbSWTxgMFdHttfkH3OyBaakTELLawbSaw7GlJFDQbGz+8WmA/Lg2vmiZPDkVKvzmJal2gPxm60fatx7ZctA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773916993; c=relaxed/simple;
	bh=XbF5GjKkZ/SNCgiiD7OtSSTkk9g/D81i6fyB9VdyZOM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qVw2VA3uPELBZOYrjumcIHx17U+sJHJl6IsE7RuRheBI3AOonTqTIaYz+LW6hpCMjRrOX9XRgHJ51/BuOhvnkkBc3BSMFaFuS5KYLlIthPQ6UZnroJEcYmi/XMRuExL6kJxo4OMYnUxplAavAor3YnCJ/xgyww/ZZYesMy7Z2Jc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eMKocdAi; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eMKocdAi; arc=fail smtp.client-ip=52.101.69.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eMKocdAi";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eMKocdAi"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=d29WRa240U9zwVPKW4KA1dS3PDW61YHoTv3IyIYL9RIl6v1SusI88xJhviyzzxDjzviNhu1H3rxxaDiclbXSlW2IYcm8T0KGl3YT6PIyYNkDzGKwbRnTGR89WdlwGnHpZUjlWl9TNadzuiGZyfdA/du/njQrGJ+ZZmR4UdYrZrPw0aTVn5M+hLkJONqgOicEIpDXhxckV/UP3X2ewk6MEORWATUMsdw8QuMHsd1cylUWkoPSwikQT4v3UhvdwgMfLSk6Df1IuDSwvDDhixXQ6/pyqbF00F4lhBWSBNbuvCj+qjuG9180IKyiSmw43U5ka9WAiSyBy1DmFYLRP7xRag==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GopXNZwZllygRxFFfV3IgV5ieTwqoANt1rNLOGc/2wY=;
 b=MCOMr7RNC7EHHklQjc3bwjnSWkRDQ41cheAemuiP3qXxo+JcExaslXGGIiezTLroA1Jka6UZ270iJb6sWppMkaQnzQkl9t3YvyaTVQdKXjJl5KhGgjevmbNETIW9tkRq1aX3fwCFG8lm/0PbdVZeicKEf1ivIfYkh3eKAmypJme0hkQTKFjYAXkXlAJmMpRAA2M3Z7DI5+p5kqDCXeSqIxLAqO2/CpO1WOxEJ/wkUJy8j4UGM6efsb6iKkIclB+vl0cbuy/lH+arXHJvLblwxyuLSla9cx5QMqGt2DFdtTfjKkH1KEmNc6Z5X/Rm7Sg+hGxZ8lGggQBom/b0EAzy2g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GopXNZwZllygRxFFfV3IgV5ieTwqoANt1rNLOGc/2wY=;
 b=eMKocdAi0HeC0ih4sicsf5ZGTryLAMQ7TFlzFi6lsgj+DgH8bwEBgPYVXcrFUu+YS3yQjk1/r2UGRVvqilayR4+wMO8uPgWR0H7egTQfqQOUIJyMkpFD6/1V1Ccusx6SB/qZ0WBrDV+ikzyCrEUne+1/ZqoZoD4Kzrc+IJ0JGp4=
Received: from AM6P191CA0026.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8b::39)
 by AM9PR08MB6003.eurprd08.prod.outlook.com (2603:10a6:20b:2d4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 10:43:05 +0000
Received: from AM3PEPF0000A790.eurprd04.prod.outlook.com
 (2603:10a6:209:8b:cafe::1b) by AM6P191CA0026.outlook.office365.com
 (2603:10a6:209:8b::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 10:43:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A790.mail.protection.outlook.com (10.167.16.119) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 10:43:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZQ09cafmAJuy2sTRC4b39VCR/nOwmZGvpAvdOPfDTr2az1V23lylgvNqlXjR9q14uC3B6IfUomLFeBzQ5hahyaPwRFGDd6UpWEJIZO+gJ3wZ7WlxD4G1fWVPAqXPhbuVnH8aGyPmMr+YBrhSheAUbi3LdNA7eK/ehu+D8Od/F8EPxhLuXk/xF0VZWKy4ZyAd0eG1Y4Bg04ThFlJvbCbsEKRLiAkaUEdeftEsrQ2wNmf+yZWjWxadAbUBTGMgOTf+P1gyjS0gVZAmjg9mVajgqzU4t9QoRLXF6gatx+JaqcDvieWj/6ydB1q0Y3+7OBjq5KYNIkD91KRU3tfMQO36pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GopXNZwZllygRxFFfV3IgV5ieTwqoANt1rNLOGc/2wY=;
 b=TJR/o1rIoSjCJgZjpWgHjiqoXq2uCyqzK4leBbb6EYR7Xs78E2+WUqYNNJpFMm7cU0BwkI657lgaayC0QQFOl+GCTSHLjFEYp6eR+Fsxn7lu47RfeD1EgpLSZPHvA/QYQGIJFlBXInjYT0dQbFKRGRt1XBOdal/Z3VzK+9fP8bPOPaR5JfNbHF4XPlQXyuMzrYSVhPBXZnIn954NU+02epPUNcZJLoa8CeR6D5PDrya82wQc6694fTHYlO2lHpqbZwxbfYrD7kzyTcYY18RDrhiguPTie7hQy7HuRU9S5MmRAYOh20dVNvaolQyNle/aHLbt74fpwGY6OwtA8y4a2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GopXNZwZllygRxFFfV3IgV5ieTwqoANt1rNLOGc/2wY=;
 b=eMKocdAi0HeC0ih4sicsf5ZGTryLAMQ7TFlzFi6lsgj+DgH8bwEBgPYVXcrFUu+YS3yQjk1/r2UGRVvqilayR4+wMO8uPgWR0H7egTQfqQOUIJyMkpFD6/1V1Ccusx6SB/qZ0WBrDV+ikzyCrEUne+1/ZqoZoD4Kzrc+IJ0JGp4=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by AS8PR08MB9094.eurprd08.prod.outlook.com (2603:10a6:20b:5b0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 10:42:00 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%5]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 10:42:00 +0000
Message-ID: <3fbd520f-2760-4075-b648-8795d1c00b9a@arm.com>
Date: Thu, 19 Mar 2026 10:41:58 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 10/48] arm64: RMI: Ensure that the RMM has GPT entries
 for memory
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
 <20260318155413.793430-11-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260318155413.793430-11-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0425.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:37d::14) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|AS8PR08MB9094:EE_|AM3PEPF0000A790:EE_|AM9PR08MB6003:EE_
X-MS-Office365-Filtering-Correlation-Id: 081e5a0f-dbc0-4912-8138-08de85a44d74
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|1800799024|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 YPMV1blSApIskpuJWoFjxNsUYSzz76SOlI5wOs6wv9xOr8G2jqw3/2NIWs9MLVjp6JGrQPuGu8uxxBjFAsmW9XW5B7oArqpecNjMV8Layhbyrl4QuzsQeFF+HlxFgkQN+bNZ5T8rUcRP8mdApevEV7Zgf7rUK24Yu+Zs+fBk4+kDCDzKK6S1s2Rn39QXtiOoD43A4sdrJDDIRFnc5vJQJaV6cbqt5TpcuxIdEwpaNtjdWqUknuKfmvmehy0K7gkdeiuEFhMAME6LhGzOgPEKMUlJWoh5HrUTN9rWOuNUs7qLWV0umJj7qwc0MNZIFF52C0HiiigrNM1WI+//vakghKG5eEG24O82qOpCobxsBS7qHn6mML0o5x+KHaEESVnqO/BhkKYZi0ySbkmI3MLx8cHOJPhD3STMNfmPprfVwddAeE3Tgvks0RJvnLbIr6lGFPa3KeDgGAg/dXqB11AChJ0kPYK1i2cuU8adxPPyLbH+HokeEcnPd7hb0FLjzn9ED0hlUqXg+MSTwf8XQ9WwBvoNBA7d8sP0C26ilw8FGt2tLpwiOPkU/J7BN5AyAYMmyS36BV5UW6zZD7tY62rbfh//nhxmffQqHMKlRUC3KLzsAbZl8Eh32c8GXXCdlznohxYvQrQrsDxlXCAQ4a+TNLWlaM6q2IM03F8x420Rx1S66kLz4zCBuoELZpOtX2J20xFQijZwkZXoK2tjt8OmqZBppWgr3Ohdjdq0vfJyIr0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 Xdv6b2QFAotpWynu1y3vcz3TUVoUnMIJmWVy54A18MVdJRLgSbWro84YEtNp46JiwLCsi4LTGsYcTDPSP/lZNn5zpeROPaUFqBs8fwZ3dB/Mux068cPnLNsVwPeH6PIik/kBXMCiUL0uC7rTOF+9KnFYR1iod0kcodS7NQrZJDlXxtBN+nzBBQp9ow9mr05YKS2iv65GOfUaN9eTngA7SLl1n9pv7wtJFZ/uFec/DHpfysHtHq5VDMb9knG5p5ztyX2eRFzpwXeV6HXbzJjr1azFLyojJicVMpjtjRBxfbbEwvGRfgtPzu5bPtyVD7VT+IC9tZQ8LcIRgJB4t5qFZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9094
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A790.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d0502e72-857d-4719-83be-08de85a426a6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|1800799024|82310400026|14060799003|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bH21rjxAgyAlSQMP7iukWd5QO0bMz7a5I4ia33/2RRQeieTXIA8ym6GE7pjy9P2oFpSXmKMo0fRc6/eejheqk9qcK8LmxW0kiHBYENyaJS9uLe5nI/whX1P1d4BxavrJkZewx0qy2S12xLChOZczSuXagUzun8h1AFl042tkIXdznh+RykQu6ykFePcM9X74/lQjbPCkoRsskf/uKQ13aB83nz5LHxyTPlF+L3QSqtHXXXQkRnK6GwRVxFdzzj1qVTg8X0TnJkaiXweSIg8sXXFOoGQxxn1MndQszMr53BApBLHcZQMWZRcHZBIyHwJS/qudFCbpoFeF172MC4tbybc2/dHg6QMZFvRES7IEpIC12NKq3G/2piJyTUhaaxEqJKtOHEsCq4AQyzWBAfbdxwmsOym3owKFkBUmI0eE/cy1HsfC6/ZcIWixtkizqWoGUKAUF0h6bo+/MzkBeEA2pAtUfjHrrOhcEDmEJkKlmHTb3zJXVOXpd+qBxFdvU2FRJzzlrnGrJLdObZi6yW3ekkLMoySX1RuV5McS+HFEgqGVl9oC5F4YaSVBzjum+upyYE9eQ82QLQ8NBfE1i5l3wFf0eYfko5GAZRhz/20fdOnV5lLPDwO/WcL9MencLZsWg+QGniOPvE5P1nZ2mZnSfXwMYqBfIl36oK3YpbWd5a9Wlm7VAeYatGpKpGziVoi7XE7XFKRP3bwque9dDtWabNpEZ+CFKPuHTtziOWoaH2ZqtGQ/qF+sQE2cP2KdjSswR3b/ZGrPQmL2lkgJ45+7KA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(1800799024)(82310400026)(14060799003)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+8mklvwNRnFMKSBye+PPaO+xV1ET3pkHCQlpMSc6PObFVuf8HU+N5WFMP2fzjlG65cpjfzwMzeXFQ/jx4P8AOm+6D0GcJb+NWWQCTJIPcIFkHZbrak3GnjE1Bdx7IUWn+8RGawMBh76ww/pE0uzeQeqmlUl3UyrJ13d3FGcyyd39IbIFqupLXav+c+NJhLAhnnPguUikgYYaFJ4nmE0SHIRYaDVv6Rcmm+TLKLvG4uDXLIWq6pkqfD8GtrGQkeSXmNwnDpCQhfYouP7ZQxHOPrGT7bHwRbvIO8MH/mHCYoWJv6bMFg/u/rQzHVyF8JZ5EDbcpa3GqnUXU5Gt8NSb8HUImTr3UASqNVnK4jW3496ADTOeSoDoFueYoIhmdNUQvy62hIIW7Eh+Hj/hTa0CtWoaE8IseR2xghaCAklviLJ+61+bymJ80vrLBZt/YSgR
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 10:43:05.2814
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 081e5a0f-dbc0-4912-8138-08de85a44d74
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6003

On 18/03/2026 15:53, Steven Price wrote:
> The RMM may not be tracking all the memory of the system at boot. Create
> the necessary tracking state and GPTs within the RMM so that all boot
> memory can be delegated to the RMM as needed during runtime.
> 
> Note: support is currently missing for SROs which means that if the RMM
> needs memory donating this will fail (and render CCA unusable in Linux).
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> New patch for v13
> ---
>   arch/arm64/kvm/rmi.c | 89 ++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 89 insertions(+)
> 
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 9590dff9a2c1..80aedc85e94a 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -4,6 +4,7 @@
>    */
>   
>   #include <linux/kvm_host.h>
> +#include <linux/memblock.h>
>   
>   #include <asm/kvm_pgtable.h>
>   #include <asm/rmi_cmds.h>
> @@ -56,6 +57,18 @@ static int rmi_check_version(void)
>   	return 0;
>   }
>   
> +/*
> + * These are the 'default' sizes when passing 0 as the tracking_region_size.

This is a little bit vague. Should we explicitly mention :

"For now we set the tracking_region_size to 0 for RMI_RMM_CONFIG_SET()"


> + * TODO: Support other granule sizes

nit: s/granule/Tracking/

Suzuki


> + */
> +#ifdef CONFIG_PAGE_SIZE_4KB
> +#define RMM_GRANULE_TRACKING_SIZE	SZ_1G
> +#elif defined(CONFIG_PAGE_SIZE_16KB)
> +#define RMM_GRANULE_TRACKING_SIZE	SZ_32M
> +#elif defined(CONFIG_PAGE_SIZE_64KB)
> +#define RMM_GRANULE_TRACKING_SIZE	SZ_512M
> +#endif
> +
>   static int rmi_configure(void)
>   {
>   	struct rmm_config *config __free(free_page) = NULL;
> @@ -95,6 +108,80 @@ static int rmi_configure(void)
>   	return 0;
>   }
>   
> +static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
> +{
> +	start = ALIGN_DOWN(start, RMM_GRANULE_TRACKING_SIZE);
> +	end = ALIGN(end, RMM_GRANULE_TRACKING_SIZE);
> +
> +	while (start < end) {
> +		unsigned long ret, category, state;
> +
> +		ret = rmi_granule_tracking_get(start, &category, &state);
> +		if (ret != RMI_SUCCESS ||
> +		    state != RMI_TRACKING_FINE ||
> +		    category != RMI_MEM_CATEGORY_CONVENTIONAL) {
> +			/* TODO: Set granule tracking in this case */
> +			kvm_err("Granule tracking for region isn't fine/conventional: %llx",
> +				start);
> +			return -ENODEV;
> +		}
> +		start += RMM_GRANULE_TRACKING_SIZE;
> +	}
> +
> +	return 0;
> +}
> +
> +static unsigned long rmi_l0gpt_size(void)
> +{
> +	return 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
> +				      rmm_feat_reg1));
> +}
> +
> +static int rmi_create_gpts(phys_addr_t start, phys_addr_t end)
> +{
> +	unsigned long l0gpt_sz = rmi_l0gpt_size();
> +
> +	start = ALIGN_DOWN(start, l0gpt_sz);
> +	end = ALIGN(end, l0gpt_sz);
> +
> +	while (start < end) {
> +		int ret = rmi_gpt_l1_create(start);
> +
> +		if (ret && ret != RMI_ERROR_GPT) {
> +			/*
> +			 * FIXME: Handle SRO so that memory can be donated for
> +			 * the tables.
> +			 */
> +			kvm_err("GPT Level1 table missing for %llx\n", start);
> +			return -ENOMEM;
> +		}
> +		start += l0gpt_sz;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rmi_init_metadata(void)
> +{
> +	phys_addr_t start, end;
> +	const struct memblock_region *r;
> +
> +	for_each_mem_region(r) {
> +		int ret;
> +
> +		start = memblock_region_memory_base_pfn(r) << PAGE_SHIFT;
> +		end = memblock_region_memory_end_pfn(r) << PAGE_SHIFT;
> +		ret = rmi_verify_memory_tracking(start, end);
> +		if (ret)
> +			return ret;
> +		ret = rmi_create_gpts(start, end);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>   static int rmm_check_features(void)
>   {
>   	if (kvm_lpa2_is_enabled() && !rmi_has_feature(RMI_FEATURE_REGISTER_0_LPA2)) {
> @@ -120,6 +207,8 @@ void kvm_init_rmi(void)
>   		return;
>   	if (rmi_configure())
>   		return;
> +	if (rmi_init_metadata())
> +		return;
>   
>   	/* Future patch will enable static branch kvm_rmi_is_available */
>   }

