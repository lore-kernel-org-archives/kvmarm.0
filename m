Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011049.outbound.protection.outlook.com [40.107.130.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBCF25DB0D
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 15:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.49
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094215; cv=fail; b=izT/naWTZ/xOj6SSSFFJMZOn//4gOoJFMNnHkdDZORFmUJEFcKt2NGmsRZr33Xki0X9eYnAuYAX8OBk5zlpiNcxJ77jCda3k2aoGqT9KvgYNEnXYvviIHIyDYd+4tmBc2VgdqQfTQ2hwYVnbzpLiPBq0+1gqB4ml3+iOLqJiseo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094215; c=relaxed/simple;
	bh=IjB7UlVd2HyC0vT0w68/sIZbwwsV7s6PKWmOB9hNgFQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WkYSAVdo59fhd4oNrmaceY5uI7URFviLdZTn9oerruLzQOWn8rKLm6OjyUnEV6iPdDlGfsmMOm8LoEt8m3dFZh1sI0qGrJsOzj21ZeqOnMl4ivxNrQVJQ+X0HndQ1zC7gnqOfqw5qlNOzZOj20I8fBV9HeyBWensDm/0T6yXv1I=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qOuIlsIv; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qOuIlsIv; arc=fail smtp.client-ip=40.107.130.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qOuIlsIv";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qOuIlsIv"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sTLikR6TueFfK4V9N/+ouFqa5pzRnkBp+MTFxzmddQv1N2uwmFGtKdyx+JKvrt+Srbq8lF3OGoasZwAMwrKcRhjIII+9RTOthfPKqvhxnzpydnSXJN7smmcBQhAEaq1WNl3kuoxA1EGBR2pkNBjicgbNMcoddoKw7mRnCXkAfvvk/RAhWUlq9sV1uqNgWXDs14C0eouTrjEKZCuYdTab1OWdA46xHzLH8r1LAW9PnTjZ9EWFLxFDIXc79+cgy587lkzIrPFZanFdWlL7wYV01RGuFhOvKpFnhbcH6VwzK8p/psGbcb5VCaZz1aHjunWSYKFRjdaEyYp8KNn5FGa0ew==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vep1kVp04dUrKIx4qZ1UELvubOcsET8jIiiQlcghBKc=;
 b=HrK5zCpjSUouWzF1yUbu3ActC7dD7HKafwWrViRQezpkI5gtL+RmRfjCS0eLG9YYvBS2J6a4chs1JUx7bClGFHG2AZ1MHWRqV3yQH3urfId50G6um8IL0ealTVsqGhi8euv73xNaqAvJsipwQvT8WMRTjnj7P1FoPpNxENaZ6JiIefQ0sbCSYAC1AarngUiK9Gv362MM5JKl4/GRazmijv88Hu66WT21U3qzchNljSxorYM0pkJvhC2fU8HxvDPDEEuMpyK+pmU6YCT3LJkr0M3AewPXYYt2Rm34xLOxiNxto9VS6flHnOLHl1YfvznhrvA5bKwPknxx9xstkS9D2Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vep1kVp04dUrKIx4qZ1UELvubOcsET8jIiiQlcghBKc=;
 b=qOuIlsIvElTfp90avQvYqefSQiy7m/KJCTmrn64OyUgP0paJzBfkv29ULDYFn2wgi2Iw+poCrJ5s7QTfNO0iKXslsamHYgcPhT/K06dVWXbb0XAdDz9WJaF7i2XOPHYFX014aNkKy7qsHPHheDiuiUySfZlatKOFaBoQygCmVYw=
Received: from DUZPR01CA0169.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::13) by PA4PR08MB6173.eurprd08.prod.outlook.com
 (2603:10a6:102:e5::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:56:42 +0000
Received: from DB1PEPF000509FD.eurprd03.prod.outlook.com
 (2603:10a6:10:4b3:cafe::10) by DUZPR01CA0169.outlook.office365.com
 (2603:10a6:10:4b3::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 15:56:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FD.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 15:56:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bv+YVLoVIIE9cZ0VWUcYWi2Gl5x0Pdzgm279XloawT6xdcDxwVBo6riF3A5pE3L2KrezH1sRuNcVsiLKF+UnY4NlkT97/FzChC5I6RS6eO2lomqnbJvWPo1waybnaE1umK/cw0tfuxZNB0U78Jcphyn9NLdegOxlw4cy6swYdlmkx4kOgLpMZVKJ3ey2pHQ44xcebbCwsDVggbf3yypVWkNk8/46emve1vSfuFkj9EzAyggo8agQZzn8g1zvMIyf2Mb+ArcbOR2Av+PWgRIzIQyTpg0Nu32hTfsXAZBcoRusQWfZqM7QF9aFdXtMAFMgiiZmc3ZxZuBhvuCNLXfFAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vep1kVp04dUrKIx4qZ1UELvubOcsET8jIiiQlcghBKc=;
 b=qzb/Z1psstYPbOV6JloAM7FBhZu1qTxm9j3OrKzJNvlaFVFrtsGi9fdYNOA3Nst0LN55tl4hvy6g0mcXcGZqTGSQ8hzAOqnD+cMHWmrpT8bNwpolO+neGXokeSuyWkOkCJNQ1tn8u9E3wZZuLlOGgTZGR3dl/6ZbIQzxkMwOt6//96FbQEOQnqS0I0jlbh0Xf51tlivj0b3dgnBNu9qgj1FLXOyXbnpFoZxlQl2Dpdq6eVwNsLvI6kPsA/kzb/sq1jn8zNkVh8B6c7NC61pksWjE2V53GPOCEeJ9/627suso8LPUa+QkEMbZm2f/2r7zSchgu6RvrZpV93Rn+IsFRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vep1kVp04dUrKIx4qZ1UELvubOcsET8jIiiQlcghBKc=;
 b=qOuIlsIvElTfp90avQvYqefSQiy7m/KJCTmrn64OyUgP0paJzBfkv29ULDYFn2wgi2Iw+poCrJ5s7QTfNO0iKXslsamHYgcPhT/K06dVWXbb0XAdDz9WJaF7i2XOPHYFX014aNkKy7qsHPHheDiuiUySfZlatKOFaBoQygCmVYw=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by PAWPR08MB11014.eurprd08.prod.outlook.com (2603:10a6:102:46c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:55:39 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:55:39 +0000
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
Subject: [PATCH v3 10/40] KVM: arm64: gic-v5: Introduce guest IST alloc and
 management
Thread-Topic: [PATCH v3 10/40] KVM: arm64: gic-v5: Introduce guest IST alloc
 and management
Thread-Index: AQHdCwRkIMNo+jdCqE6H51OdjKk18Q==
Date: Fri, 3 Jul 2026 15:55:38 +0000
Message-ID: <20260703154811.3355680-11-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7310:EE_|PAWPR08MB11014:EE_|DB1PEPF000509FD:EE_|PA4PR08MB6173:EE_
X-MS-Office365-Filtering-Correlation-Id: ba611ca5-8675-4e5a-766c-08ded91bac87
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|38070700021|3023799007|56012099006|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 s+ASktOY6RnlOdw7qwFP8AQwqGHCmMKjlWQbun69ojOWpOU2Z3l3ItYZTVNCtRWuEpDgHDyQsxgqAraeY7aUiC9MxB8o+KQwjfx5UrRgKb3J+drL9nAH3IVXoRpotiYlnkF8xJmDzKMS9+4dO9H/LhmF20zo8pQIYR21f/MkzIYjVSiC7S4tcCEAY4iXz5bjCLBVJ82F4cPa1ypZ6QsA1+woY8guyoTeQU8nByT1fTNDesSPlD/oakA2yV/ft+Rr3GJtVYhf2F7uvcn7t9lvkiaSwy6JQjfM7ebXqFYhBFpYH+hvoFBFmkTgky501i7Mnyj+mus71nHSsXA3CelUZ/gWPPn9/kKxtfl3HXxGpoK2uT8ORr8KumbIqFCGaLLB5gQvC556rlARor8vHEGcrdREpOPAR04RjmzbXwZ95Xx8OTEo0NqiV4NXRa1nADdkZXCapOuLg4qq1jyK3Y8rTeetnJd8k0FokQUqtQ/nC61d7QwTp00KwI31A6AvKalSEk4kZ9VJ5RBGdkblp9rf1hP3swYJ4lnvp2/+Lmi75qFhu1w2x368qVEst8RF9e9hitcUHbXQo99mumypFcuGRbC73JUgn1bHy599ThbR1FA5W5YvUbEQ55Hw9TizVWjkpOZUqniRNFHM5CgVMbkG2o9lEQs8LGHjmP/g1XZr9e3ixTRQr9oCXREQorra3thWqZN0iwTGglCC38wC06s3mATMVBCy0R/w/MP3iG22JnU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(38070700021)(3023799007)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 cKUEsEsxnCa5uXWHN8oZhqX9HKFXbnImBlUC2tmdMfIXMjRH3gM+5DNeCf3bSQfuKCMzXbdL7srhNjNDiWF53pT4U1Z1D7ggp9JlaPF1TT4aQhPovTCfOXbxuhgpm8ZzkkEAzn11yro6sakJqg1gJJL+ApThB+vvVtzF9k26vm8gMImUFZc+rfT67BceBQaAX6g2AzD82qadxuFzn7+BbfQ0l7qpMAspf236xwdcD44K2UHdmWbQFzNPkZv1uFL3+aWBVGbj3H0VsJborykmZePOop8RcYi7AmUvfk6pl/bq+7fxi/mNG3dEAq1eHloCqXG9XW08IAkdKzGJJu0+lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11014
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FD.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	138ec18d-b9df-4dbf-f452-08ded91b8748
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|35042699022|23010399003|36860700016|1800799024|82310400026|11063799006|56012099006|3023799007|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Tjs3PmkO+ug4z8fl2mcrAQPWRv8U6gHCIiQPlD4P5F8nObJ28SXaXSFfB1tNRaCPY2rp3ZmcOuuTNysLdjOUGmIWneBDgtxPmRUMExM9RkKP1Jrda8Mc4ATq9u9oBePLTFs4G3X9Iw4kGe7e98z6BEML3A88/pv6aLMH8aac3TrshJyVoaE+DEPX+pef5iTVOROuJ03NvRyqH9OmGOoNjn6Xdg1b1Cour+opkG6sYIl1OlG/FUt7Hcv+AnbLH6Mv20u7LbWldNsDUXpyo8ZmCHUa+MJwke69lmdb2X0QSEAWQ+ZnlTFJdliojCmKnoa9yAAJOa2exMbxEaM+RgrmpF3/hd+IwkTsImTJnGLcXcQK7xL+TKmO81Bkw/Uym+RkBccFdAwmSJioOClJ8LDepSrjttFCWv3yNaBaciWZKUiwe+AOyC1w1KIKWmNwtAtjQr4mNXiEPfc9TTXF9u8oX23nKoHTUI6UObVruelqi+LoLW6AwoVfq7IgRceve4vfvBmVtQADDIspZtrO16V51C5zaZCMr51soKGdigbZ1yqiFyhnwMKd7T9mLwA7up9qyQlRwwMBoX8zpaRuaRvxJQWUapum02Z5qzUemDt/1uKdIgBfxX2RJHZicN5SmRgsTLkcIRBvsllj7rNDB01eMmmYj2uPE9bxZbmI3roiURcMLuTFsGZZf5vCM2woY1NYHTP1Esq3oC+LDE75nymRRw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(35042699022)(23010399003)(36860700016)(1800799024)(82310400026)(11063799006)(56012099006)(3023799007)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lhC3dgMZHgW0EOPsDPYRp0mlzIFPBA/Vy2Bvny3Z0T4uYzuTVB7iS9t7vSqVUXRYmv+vA3CX7+pQ2tW1E8nDkUjwaTbWAa2GFK99sOfgGKuVwv6MZi3eQcX1CFPPY1uMHRddDXPVW3j3xOSaffP2Rc42a0zTV2ItwJ8t7ToKwZbWlGL2kuHZIDHh/zdp7hbeDVS7T47YvwP2+sXscbvTpB3vYo+dNbuq3ytR5SKzAmC6edeacqEVsKNPOkxUcGMyRBnDW2z8hzyib7OBkW13e/LfcM4oh0Dl7Sr3QyEWIpKG/m9RVs/97lz85b5nWSo08N5maBSQiFsil0y1APgcj6hXDJceVQYA2B351Mrcs+bTNma9E8KegnUZmfQBDHf5Nwu5D4LVuxUfhU1WOtu6MqRx9AJNnS/9F1ym07YEe/yDUrCix9ny6W31LjnfBC5N
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 15:56:41.3998
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba611ca5-8675-4e5a-766c-08ded91bac87
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FD.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6173

GICv5 guests use Interrupt State Tables (ISTs) to track and manage the
interrupt state for SPIs and LPIs. These ISTs are provided to the host's
IRS via the VMTE.

On a host GICv5 system, SPIs do not require any up-front memory
allocation prior to their use, unlike LPIs which require the OS to
allocate an IST. For a GICv5 guest, the same holds from the guest's
point of view: SPIs should require no explicit memory allocation by the
guest. This means that KVM must provision the memory passed to the IRS
for managing a guest's SPI state.

Allocate the SPI IST before running the guest for the first time. As only
a small number of SPIs are expected, this is always allocated as a linear
IST. The host is responsible for freeing this memory on guest teardown.

For LPIs, the guest provisions memory for its LPI IST. KVM does not pass
that memory directly to the host IRS. Instead, allocate a shadow LPI IST
and pass that to the IRS through the VMTE. The LPI IST may be allocated
as a two-level structure when supported and required by the configured
LPI ID space, as many more LPIs are expected than SPIs. The host frees
this memory on guest teardown.

This commit also extends the doorbell domain to allow the doorbells
themselves to act as a conduit for issuing commands, similar to what
exists for GICv4 support. Effectively, irq_set_vcpu_affinity() becomes
an ioctl-like interface for issuing commands specific to either a VM or
the particular VPE that the doorbell belongs to. Add support for:

        VMT_L2_MAP - Make a second level VM table valid
        VMTE_MAKE_VALID - Make a single VMTE, and hence VM, valid
        VMTE_MAKE_INVALID - Make a single VMTE, and hence VM, invalid
        SPI_VIST_MAKE_VALID - Make the SPI IST valid
        LPI_VIST_MAKE_VALID - Make the LPI IST valid
        LPI_VIST_MAKE_INVALID - Make the LPI IST invalid

None of these commands are plumbed through to the host IRS at this
stage.

There is intentionally no SPI_VIST_MAKE_INVALID command. The SPI IST is
allocated as part of VM creation and is not invalidated while the VM is
live. It is freed when the VM is destroyed, after the VMTE has been made
invalid. The LPI IST, on the other hand, is driven by the guest, which is
free to invalidate and free its LPI IST at any point.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5-tables.c | 538 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h |  22 ++
 arch/arm64/kvm/vgic/vgic-v5.c        |   3 +
 include/linux/irqchip/arm-gic-v5.h   |   3 +
 4 files changed, 566 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index db8cb6a384994..79b305d2d5097 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -59,6 +59,14 @@ static DEFINE_XARRAY(vm_info);
 #define GICV5_VPED_ADDR_SHIFT		3ULL
 #define GICV5_VPED_ADDR			GENMASK_ULL(55, 3)
=20
+/*
+ * The LPI and SPI configuration is stored in the 2nd and 3rd 64-bit chunk=
s of
+ * the VMTE (0-based). We call this a section here in an attempt to simpli=
fy the
+ * code.
+ */
+#define GICV5_VMTEL2_LPI_SECTION	2
+#define GICV5_VMTEL2_SPI_SECTION	3
+
 /*
  * Our IRS might be coherent or non-coherent. If coherent, we can just emi=
t a
  * DSB to ensure that we're in sync. However, when non-coherent, we need t=
o
@@ -495,6 +503,25 @@ int vgic_v5_vmte_init(struct kvm *kvm)
 	return ret;
 }
=20
+/*
+ * The following set of forward declarations makes the code layout a *litt=
le*
+ * clearer as it lets us keep the IST-related code together.
+ */
+static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
+				    unsigned int id_bits,
+				    unsigned int istsz);
+static int vgic_v5_alloc_l1_ist(struct kvm *kvm, unsigned int id_bits,
+				unsigned int istsz, unsigned int l2_split);
+static int vgic_v5_alloc_l2_ists(struct kvm *kvm, unsigned int id_bits,
+				 unsigned int istsz, unsigned int l2_split);
+static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm,
+					   unsigned int id_bits,
+					   unsigned int istsz,
+					   unsigned int l2_split);
+static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi);
+static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi);
+static int vgic_v5_spi_ist_free(struct kvm *kvm);
+
 /*
  * Release the VMT Entry, freeing up any allocated data structures before
  * zeroing the VMTE.
@@ -527,6 +554,20 @@ int vgic_v5_vmte_release(struct kvm *kvm)
 	kfree(vmi->vpet_base);
 	kfree(vmi->vmd_base);
=20
+	/* If we have an LPI IST, free it */
+	if (vmi->h_lpi_ist) {
+		ret =3D vgic_v5_lpi_ist_free(kvm);
+		if (ret)
+			return ret;
+	}
+
+	/* If we have an SPI IST, free it */
+	if (vmi->h_spi_ist) {
+		ret =3D vgic_v5_spi_ist_free(kvm);
+		if (ret)
+			return ret;
+	}
+
 	xa_erase(&vm_info, vm_id);
 	kfree(vmi);
=20
@@ -629,3 +670,500 @@ int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
=20
 	return 0;
 }
+
+/*
+ * Assign an already allocated IST to the VM by populating the fields in t=
he
+ * corresponding VMTE. We re-use this code for both an SPI IST and LPI IST=
, even
+ * if the paths to reach it might be vastly different.
+ */
+static int vgic_v5_vmte_assign_ist(struct kvm *kvm, phys_addr_t ist_base,
+				   bool two_level, unsigned int id_bits,
+				   unsigned int l2sz, unsigned int istsz,
+				   bool spi_ist)
+{
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	enum gicv5_vcpu_cmd cmd;
+	struct vmtl2_entry *vmte;
+	unsigned int section;
+	u64 tmp;
+	int ret;
+
+	/*
+	 * The L2 VMTE comprises four 64-bit "sections", where sections 2 & 3
+	 * describe the LPI and SPI ISTs, respectively. Both the LPI and SPI
+	 * sections have the same layout, and as we are either operating on SPIs
+	 * or LPIs we pick a section of the VMTE to modify up-front.
+	 *
+	 * See the GICv5 EAC0 Specification 11.2.2 for more details about the
+	 * VMTE layout.
+	 */
+	section =3D spi_ist ? GICV5_VMTEL2_SPI_SECTION : GICV5_VMTEL2_LPI_SECTION=
;
+
+	if (ist_base & ~GICV5_VMTEL2E_IST_ADDR) {
+		kvm_err("IST alignment issue! Address: 0x%llx, Mask 0x%llx\n",
+			ist_base, GICV5_VMTEL2E_IST_ADDR);
+		return -EINVAL;
+	}
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	/* Bail if already allocated */
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+	if (le64_to_cpu(READ_ONCE(vmte->val[section])) & GICV5_VMTEL2E_IST_VALID)
+		return -EINVAL;
+
+	tmp =3D FIELD_PREP(GICV5_VMTEL2E_IST_L2SZ, l2sz);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_ADDR,
+			ist_base >> GICV5_VMTEL2E_IST_ADDR_SHIFT);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_ISTSZ, istsz);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_ID_BITS, id_bits);
+	if (two_level)
+		tmp |=3D GICV5_VMTEL2E_IST_STRUCTURE;
+
+	WRITE_ONCE(vmte->val[section], cpu_to_le64(tmp));
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+
+	/* Finally, mark the entry as valid */
+	cmd =3D spi_ist ? SPI_VIST_MAKE_VALID : LPI_VIST_MAKE_VALID;
+	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);
+
+	return ret;
+}
+
+/*
+ * Allocate a Linear IST - always used for SPIs and potentially LPIs.
+ *
+ * The calculation for n has been taken from section 11.2.2 of the GICv5 E=
AC0
+ * spec.
+ *
+ * NOTE: istsz is the FIELD used by GICv5, not the actual size (or log2() =
of the
+ * size).
+ */
+static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
+				    unsigned int id_bits, unsigned int istsz)
+{
+	const size_t n =3D id_bits + 1 + istsz;
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	__le64 *ist;
+	u32 l1sz;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	/*
+	 * Allocate the IST. We only have one level, so we just use the L2 ISTE.
+	 */
+	l1sz =3D BIT(n + 1);
+	ist =3D kzalloc(l1sz, GFP_KERNEL_ACCOUNT);
+	if (!ist)
+		return -ENOMEM;
+
+	if (spi_ist) {
+		vmi->h_spi_ist =3D ist;
+	} else {
+		vmi->h_lpi_ist_structure =3D false;
+		vmi->h_lpi_ist =3D ist;
+	}
+
+	vgic_v5_clean_inval(ist, l1sz);
+
+	return 0;
+}
+
+/*
+ * Allocate the first level of a two-level IST - LPI, only.
+ *
+ * The calculation for n has been taken from section 11.2.2 of the GICv5 E=
AC0
+ * spec.
+ *
+ * NOTE: istsz and l2sz are the FIELDS used by GICv5, not the actual sizes=
 (or
+ * log2() of the sizes).
+ */
+static int vgic_v5_alloc_l1_ist(struct kvm *kvm, unsigned int id_bits,
+				unsigned int istsz, unsigned int l2sz)
+{
+	const size_t n =3D  max(5, id_bits - ((10 - istsz) + (2 * l2sz)) + 3 - 1)=
;
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	const u32 l1_size =3D BIT(n + 1);
+	struct vgic_v5_vm_info *vmi;
+	__le64 *ist;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	ist =3D kzalloc(l1_size, GFP_KERNEL_ACCOUNT);
+	if (!ist)
+		return -ENOMEM;
+
+	vmi->h_lpi_ist_structure =3D true;
+	vmi->h_lpi_ist =3D ist;
+
+	vgic_v5_clean_inval(ist, l1_size);
+
+	return 0;
+}
+
+/*
+ * Allocate ALL of the second level ISTs for a two-level IST - LPI, only.
+ *
+ * The calculation for n has been taken from section 11.2.2 of the GICv5 E=
AC0
+ * spec. The l2_size calculation is from section 11.2.3 of the same docume=
nt.
+ *
+ * NOTE: istsz and l2sz are the FIELDS used by GICv5, not the actual sizes=
 (or
+ * log2() of the sizes).
+ */
+static int vgic_v5_alloc_l2_ists(struct kvm *kvm, unsigned int id_bits,
+				 unsigned int istsz, unsigned int l2sz)
+{
+	const size_t n =3D  max(5, id_bits - ((10 - istsz) + (2 * l2sz)) + 3 - 1)=
;
+	const int l1_entries =3D BIT(n + 1) / GICV5_IRS_ISTL1E_SIZE;
+	const size_t l2_size =3D BIT(11 + (2 * l2sz) + 1);
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	__le64 *l2ist;
+	__le64 *l1ist;
+	int index;
+	u64 val;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	l1ist =3D vmi->h_lpi_ist;
+
+	/*
+	 * Allocate the storage for the pointers to the L2 ISTs (used when
+	 * freeing later).
+	 */
+	vmi->h_lpi_l2_ists =3D kzalloc_objs(*vmi->h_lpi_l2_ists, l1_entries,
+					  GFP_KERNEL_ACCOUNT);
+	if (!vmi->h_lpi_l2_ists)
+		return -ENOMEM;
+
+	/* Allocate the L2 IST for each L1 IST entry */
+	for (index =3D 0; index < l1_entries; ++index) {
+		l2ist =3D kzalloc(l2_size, GFP_KERNEL_ACCOUNT);
+		if (!l2ist) {
+			while (--index >=3D 0)
+				kfree(vmi->h_lpi_l2_ists[index]);
+
+			kfree(vmi->h_lpi_l2_ists);
+			vmi->h_lpi_l2_ists =3D NULL;
+
+			return -ENOMEM;
+		}
+
+		/*
+		 * We are not doing on-demand allocation of the L2 ISTs, and are
+		 * instead provisioning the whole IST up front. This means that
+		 * we are able to mark the L2 ISTs as valid in the L1 ISTEs as
+		 * the overall IST is not yet valid.
+		 */
+		val =3D (virt_to_phys(l2ist) & GICV5_ISTL1E_L2_ADDR_MASK) |
+		      GICV5_ISTL1E_VALID;
+		l1ist[index] =3D cpu_to_le64(val);
+
+		vmi->h_lpi_l2_ists[index] =3D l2ist;
+
+		vgic_v5_clean_inval(l2ist, l2_size);
+	}
+
+	/* Handle CMOs for the whole L1 IST in one go */
+	vgic_v5_clean_inval(l1ist, l1_entries * sizeof(*l1ist));
+
+	return 0;
+}
+
+/* Allocate a two-level IST - LPIs, only */
+static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm, unsigned int i=
d_bits,
+					   unsigned int istsz, unsigned int l2sz)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	int ret;
+
+	/*
+	 * Allocate the L1 IST first, then all of the L2s. Everything
+	 * is preallocated and we do no on-demand IST allocation. This
+	 * is to avoid needing to track if and when the guest is doing
+	 * on-demand IST allocation.
+	 */
+	ret =3D vgic_v5_alloc_l1_ist(kvm, id_bits, istsz, l2sz);
+	if (ret)
+		return ret;
+
+	ret =3D vgic_v5_alloc_l2_ists(kvm, id_bits, istsz, l2sz);
+	if (ret) {
+		/* Free the L1 IST again */
+		vmi =3D xa_load(&vm_info, vm_id);
+		kfree(vmi->h_lpi_ist);
+		vmi->h_lpi_ist =3D 0;
+
+		return ret;
+	}
+
+	return 0;
+}
+
+static void vgic_v5_free_allocated_lpi_ist(struct vgic_v5_vm_info *vmi,
+					   unsigned int id_bits,
+					   unsigned int istsz,
+					   unsigned int l2sz)
+{
+	if (!vmi->h_lpi_ist_structure) {
+		kfree(vmi->h_lpi_ist);
+		vmi->h_lpi_ist =3D NULL;
+		return;
+	}
+
+	if (vmi->h_lpi_l2_ists) {
+		const size_t n =3D max(5, id_bits - ((10 - istsz) + (2 * l2sz)) + 3 - 1)=
;
+		const int l1_entries =3D BIT(n + 1) / GICV5_IRS_ISTL1E_SIZE;
+		int index;
+
+		for (index =3D 0; index < l1_entries; ++index)
+			kfree(vmi->h_lpi_l2_ists[index]);
+
+		kfree(vmi->h_lpi_l2_ists);
+		vmi->h_lpi_l2_ists =3D NULL;
+	}
+
+	kfree(vmi->h_lpi_ist);
+	vmi->h_lpi_ist =3D NULL;
+}
+
+static void vgic_v5_free_allocated_spi_ist(struct kvm *kvm)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return;
+
+	kfree(vmi->h_spi_ist);
+	vmi->h_spi_ist =3D NULL;
+}
+
+/*
+ * Free a Linear IST. Can only happen once the VM is dead.
+ */
+static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vmtl2_entry *vmte;
+	struct vgic_v5_vm_info *vmi;
+	int section;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	if (spi) {
+		section =3D GICV5_VMTEL2_SPI_SECTION;
+		vgic_v5_free_allocated_spi_ist(kvm);
+	} else {
+		section =3D GICV5_VMTEL2_LPI_SECTION;
+		vgic_v5_free_allocated_lpi_ist(vmi, 0, 0, 0);
+	}
+
+	/* The VM should be dead here, so we can just zero the VMT section */
+	vmte->val[section] =3D cpu_to_le64(0);
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+
+	return 0;
+}
+
+/*
+ * Free a Two-Level IST. Can only happen once the VM is dead.
+ */
+static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi)
+{
+	unsigned int id_bits, istsz, l2sz;
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	struct vmtl2_entry *vmte;
+	__le64 tmp;
+	int section;
+
+	/* We don't create two-level SPI ISTs, so freeing is a bad idea! */
+	if (spi)
+		return -EINVAL;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	section =3D GICV5_VMTEL2_LPI_SECTION;
+
+	if (!vmi->h_lpi_ist_structure)
+		return -EINVAL;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	tmp =3D le64_to_cpu(READ_ONCE(vmte->val[section]));
+
+	id_bits =3D FIELD_GET(GICV5_VMTEL2E_IST_ID_BITS, tmp);
+	istsz =3D FIELD_GET(GICV5_VMTEL2E_IST_ISTSZ, tmp);
+	l2sz =3D FIELD_GET(GICV5_VMTEL2E_IST_L2SZ, tmp);
+
+	vgic_v5_free_allocated_lpi_ist(vmi, id_bits, istsz, l2sz);
+
+	/* The VM must be dead, so we can just zero the VMT section */
+	vmte->val[section] =3D cpu_to_le64(0);
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+
+	return 0;
+}
+
+/* Helper to determine ISTE size based on metadata requirements */
+static unsigned int vgic_v5_ist_istsz(unsigned int id_bits)
+{
+	if (!irs_caps.istmd)
+		return GICV5_IRS_IST_CFGR_ISTSZ_4;
+
+	if (id_bits >=3D irs_caps.istmd_sz)
+		return GICV5_IRS_IST_CFGR_ISTSZ_16;
+
+	return GICV5_IRS_IST_CFGR_ISTSZ_8;
+}
+
+/*
+ * Allocate an IST for SPIs.
+ *
+ * We don't anticipate a large number of SPIs being allocated. Therefore, =
we
+ * always allocate a Linear IST for SPIs. This will need to be revisited s=
hould
+ * that assumption no longer hold.
+ */
+int vgic_v5_spi_ist_alloc(struct kvm *kvm, unsigned int id_bits)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	phys_addr_t base_addr;
+	unsigned int istsz;
+	int ret;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	istsz =3D vgic_v5_ist_istsz(id_bits);
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	if (vmi->h_spi_ist)
+		return -EBUSY;
+
+	ret =3D vgic_v5_alloc_linear_ist(kvm, true, id_bits, istsz);
+	if (ret)
+		return ret;
+	base_addr =3D virt_to_phys(vmi->h_spi_ist);
+
+	ret =3D vgic_v5_vmte_assign_ist(kvm, base_addr, false, id_bits, 0, istsz,
+				      true);
+	if (ret) {
+		vgic_v5_free_allocated_spi_ist(kvm);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Free the IST for SPIs. Should only happen once the VM is dead.
+ */
+static int vgic_v5_spi_ist_free(struct kvm *kvm)
+{
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	return vgic_v5_linear_ist_free(kvm, true);
+}
+
+/*
+ * Allocate an IST for LPIs.
+ *
+ * Unlike with SPIs, we anticipate that the guest will allocate a relative=
ly
+ * large number of LPIs. Therefore, while we support doing a linear LPI IS=
T, it
+ * is expected that LPI ISTs will be two-level.
+ */
+int vgic_v5_lpi_ist_alloc(struct kvm *kvm, unsigned int id_bits)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	unsigned int istsz, l2sz;
+	phys_addr_t phys_addr;
+	bool two_level;
+	int ret;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	if (vmi->h_lpi_ist)
+		return -EBUSY;
+
+	istsz =3D vgic_v5_ist_istsz(id_bits);
+	l2sz =3D gicv5_irs_l2_sz(irs_caps.ist_l2sz);
+
+	/*
+	 * Determine if we want to create a Linear or a Two-Level IST.
+	 *
+	 * A two-level IST is only required when a single L2 IST cannot cover
+	 * the requested ID space. This depends on the L2 IST size selected for
+	 * the IRS, not PAGE_SIZE. Using PAGE_SIZE here would switch to
+	 * two-level too early when the selected L2 IST is larger than a page,
+	 * and the allocation sizing arithmetic would underflow.
+	 */
+	two_level =3D irs_caps.ist_levels &&
+		id_bits > ((10 - istsz) + (2 * l2sz));
+
+	if (!two_level)
+		ret =3D vgic_v5_alloc_linear_ist(kvm, false /* LPIs, not SPIs */,
+					       id_bits, istsz);
+	else
+		ret =3D vgic_v5_alloc_two_level_lpi_ist(kvm, id_bits, istsz,
+						      l2sz);
+
+	if (ret)
+		return ret;
+
+	phys_addr =3D virt_to_phys(vmi->h_lpi_ist);
+	ret =3D vgic_v5_vmte_assign_ist(kvm, phys_addr, two_level, id_bits, l2sz,
+				      istsz, false);
+	if (ret)
+		vgic_v5_free_allocated_lpi_ist(vmi, id_bits, istsz, l2sz);
+
+	return ret;
+}
+
+/* Free the LPI IST again */
+int vgic_v5_lpi_ist_free(struct kvm *kvm)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -ENXIO;
+
+	if (!vmi->h_lpi_ist_structure)
+		return vgic_v5_linear_ist_free(kvm, false);
+	else
+		return vgic_v5_two_level_ist_free(kvm, false);
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index b763dc3a60e3a..d0b743e8d957a 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -25,6 +25,24 @@ struct vgic_v5_vm_info {
 	vpe_entry __iomem	*vpet_base;
 	void __iomem		**vped_ptrs;
 	u8			vpe_id_bits;
+
+	/*
+	 * Both the LPI and SPI ISTs are allocated by the hypervisor. While it
+	 * would be possible to track and access them by iterating over the ISTs
+	 * themselves, it makes more sense to store pointers to the ISTs.
+	 *
+	 * The LPI IST can either be two-level or linear. Hence, we keep track
+	 * of the structure. If it is two-level, we retain pointers to the L1
+	 * IST and to each L2 IST array. If it is linear, we just store the base
+	 * address of the IST array.
+	 *
+	 * The SPI IST is linear, and therefore we just store the base address
+	 * of the SPI IST array.
+	 */
+	bool			h_lpi_ist_structure;
+	__le64			*h_lpi_ist;
+	__le64			**h_lpi_l2_ists;
+	__le64			*h_spi_ist;
 };
=20
 struct vgic_v5_vmt {
@@ -73,4 +91,8 @@ int vgic_v5_vmte_release(struct kvm *kvm);
 int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
=20
+int vgic_v5_spi_ist_alloc(struct kvm *kvm, unsigned int id_bits);
+int vgic_v5_lpi_ist_alloc(struct kvm *kvm, unsigned int id_bits);
+int vgic_v5_lpi_ist_free(struct kvm *kvm);
+
 #endif
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 089170f513350..02d5e383a87ed 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -161,6 +161,9 @@ static int vgic_v5_db_set_vcpu_affinity(struct irq_data=
 *data, void *vcpu_info)
 	case VMT_L2_MAP:
 	case VMTE_MAKE_VALID:
 	case VMTE_MAKE_INVALID:
+	case SPI_VIST_MAKE_VALID:
+	case LPI_VIST_MAKE_VALID:
+	case LPI_VIST_MAKE_INVALID:
 		/* Not yet implemented */
 	default:
 		return -EINVAL;
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 27b13bf2c1e2c..74152d22de070 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -659,6 +659,9 @@ enum gicv5_vcpu_cmd {
 	VMT_L2_MAP,		/* Map in a L2 VMT - *may* happen on VM init */
 	VMTE_MAKE_VALID,	/* Make the VMTE valid */
 	VMTE_MAKE_INVALID,	/* Make the VMTE (et al.) invalid */
+	SPI_VIST_MAKE_VALID,	/* No corresponding invalid */
+	LPI_VIST_MAKE_VALID,	/* Triggered by a guest */
+	LPI_VIST_MAKE_INVALID,	/* Triggered by a guest */
 };
=20
 #endif
--=20
2.34.1
