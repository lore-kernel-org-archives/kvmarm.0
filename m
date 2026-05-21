Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013056.outbound.protection.outlook.com [52.101.83.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F27312807
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 15:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.56
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375825; cv=fail; b=ug+gGHsapV61O8G6FORejwqXnLckYCk2FxhM6US+gE5KUkDB6RPwKF0vJU3UUenSmx3xAVeZyoeMDVFVgW7j/+YHj9z8jgFvhQUQYHU/AOKtY84Xd6vFkzmEzPXCCxvT7VtJH90TwNZSo/xgRDGpFo6Xbpb6hQ098pcdPq21if0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375825; c=relaxed/simple;
	bh=u2bmOAYVgCJ4AVkoewK8uosaWTCrSeiFU7NIiopnmbc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PGiO8da8Z1MIKQZiplgQVqxFrjdyH6cS6ECbX85MRRwoIiocwp7y+pf1nmW6EiQFdLs0+Eh7Gjg4qtSBPOy4lLWJRaew3Igfi43TJQSXkRm+plP2IwlLviUIzOUFE6uz+b2GqeP5e+DgdQhTBBq/1iTDKngg6ZkmYVg1Qzhaa/E=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gnKZdwZa; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gnKZdwZa; arc=fail smtp.client-ip=52.101.83.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gnKZdwZa";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gnKZdwZa"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=VAupM8Kf56V665HyRxybJ8tBBaxRC9tbOAwRE62W0S2EcvKSMTbTElP2RoatTNuAdvGSElLCqSSynvkirNPgRjcnMacJzkbI7YQytP83f6U1BOc3Cc7HZkQQB8Fr1T9waVJ7DnANKX42sP/heTmAXBLN2kV+T1gXicIiNj1cajeTKy6Mzgw5/uc4Ow82PmuHjSgvoWJ+kH+XZjmDBYle4bqJTs3zEPWeKfbcH11WoFFJXsza8KZpFZNba9Qhmgygun3t/OT9g9HXeE+OjJUiFdyzJ6NsoXbLfP3X+RUX5YLO1v5lm27djfYYLsgWuV27ywIvrY3Qg/ui9hs90YiAYQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAZBvedpnT1n1TJaLvuO0NRyKDu5mX2BQAxWXLbvPms=;
 b=bS0djaR5dEU44jv8THjQS6tobkpyBV3R81cQa9BLaLTu6kCYZtgVl7TskHBC4DMs1IpHkMtzosm9zY5jG7360O8t+CtFPHsVMTvK9A0Pap3VaD2590eHnpgT5oFLHuIa+2hitv2QygQEyDT64zZcq40Eq0+S2JVK8wNTQixs5BchBRzwvZlTeCxmyW+odU/MYMakCJiZOovV9VZtnuO/8OqdwxsbqrvdOm0C0lyMBEXfAEoqN8xgpeqnQy3/mYqx8EkXoES3BhxgK8Pkb6ERCbR+s4DfM4eGz+pcGkFmrkrKLyC9gABXChpEWp6kjyiFSDq4bOhI8rQkgZWWefp01Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAZBvedpnT1n1TJaLvuO0NRyKDu5mX2BQAxWXLbvPms=;
 b=gnKZdwZaz+jQ0c5PwUXRvRrXXXF4Xo9NJlEn9edXj3N5IbzWPvNpvHnUCEAvEYyDXN5+e8cys3XgMrz2evNe8OkCJVcURYdljHvXvHrhTkc9cNWs7qIIzuEOmbS0mh30tT09ARy8LMGbfC0qWPguU79fR0lVlbuIIkn0yJxgJjY=
Received: from DB9PR01CA0011.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:1d8::16) by AS8PR08MB6326.eurprd08.prod.outlook.com
 (2603:10a6:20b:335::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 15:03:37 +0000
Received: from DB3PEPF0000885B.eurprd02.prod.outlook.com
 (2603:10a6:10:1d8:cafe::51) by DB9PR01CA0011.outlook.office365.com
 (2603:10a6:10:1d8::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 15:03:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885B.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 15:03:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=apPBOwlZgFse2YVmPnNy0XRaUG/zsY4KT2TGOUBJYsChV3xj0eCIWk251/vi/mkUAIIW4aksnru80+vWpHVmanjTidyqLuaoX9sDk5lvrZSJkKndhluhyvD1uyJMhijbiu8Kl50TUcmkmPo5EoF3/6ihURfyRWJusODkV9Kku168vNAzfG46+FJJCCwaVCFKQglwkYXXS/8EF4i/H8WQpwiah5NlqiVUUiRQm8GbrIO0ZsSZLLoKCmkQPyUVJd6OqYnTV4vNzXVbmYgBLR2DczIHM/NE8UpnqMMmhKC1YzPsLx8rPULUutPijAURxenVokZMDSYLHy5fyLIiLL/MQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAZBvedpnT1n1TJaLvuO0NRyKDu5mX2BQAxWXLbvPms=;
 b=MYvOYY9bG09RHayavoUf85nQO9gt0Uwn55mbBxYtxXF/202x4ZucnCo4/zYQ9bYA30/SvHail1QJBAb2ScsgAhuVUQ0BIysXW+nZ08oUzxCF8F7JZ1iq4FekFvJ2U8v/dFODcH26DSmf0ETlQ7eXTT1iostUyIbm4tBwbNhS1/lN7HNv0vGuvn1fS3hlUa0SAPMsv97oDGL7WI86r8oIbW3GsRXt+fVnd5O/ejv0tjpMN2Pw6uWIYmmwuss4ydCZEbjeRmf2CFGS07rcCHKKCkT9Z14D0WgAI5ISbxv1/1bIDug1aNC8LM9/TpC0ZsbGtnlVlezqUtQepg3iwY/K8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAZBvedpnT1n1TJaLvuO0NRyKDu5mX2BQAxWXLbvPms=;
 b=gnKZdwZaz+jQ0c5PwUXRvRrXXXF4Xo9NJlEn9edXj3N5IbzWPvNpvHnUCEAvEYyDXN5+e8cys3XgMrz2evNe8OkCJVcURYdljHvXvHrhTkc9cNWs7qIIzuEOmbS0mh30tT09ARy8LMGbfC0qWPguU79fR0lVlbuIIkn0yJxgJjY=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DBBPR08MB6204.eurprd08.prod.outlook.com (2603:10a6:10:1f5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 15:02:34 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 15:02:34 +0000
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
Subject: [PATCH v2 39/39] Documentation: KVM: Add the VGICv5 IRS save/restore
 sequences
Thread-Topic: [PATCH v2 39/39] Documentation: KVM: Add the VGICv5 IRS
 save/restore sequences
Thread-Index: AQHc6TLaF07Hz6ybrUezlwqUkv2b7g==
Date: Thu, 21 May 2026 15:02:34 +0000
Message-ID: <20260521144846.1899475-40-sascha.bischoff@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
In-Reply-To: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|DBBPR08MB6204:EE_|DB3PEPF0000885B:EE_|AS8PR08MB6326:EE_
X-MS-Office365-Filtering-Correlation-Id: e2e5b7fc-7d10-446f-4edc-08deb74a22b3
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003|38070700021|5023799004|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 wkRQv91bqoE3xGGGCa2xqJP2Zz6NjNgbTiTVhexTilunkZm/SHTTq/j/UYFbLScAamm2Oq3Zf3NRVtEiYWtjVkVz/g7YDt5+fKRp6x6q6LAvGJFKlWlZ2hiwPzicsM48XFaEF3TobckhMwJNGli7Jqb9/wu/eSRRHuNgNbOURscS/shur0/E0TlzM696o0OkbZ6OomuAow0UM1+lVV3UC1wL7zhQvytiisakmKWD2VILK6cpHByFvo68MBddUqAvcYQgV6Q4ZG0+rLZag9h/fv6/ybEAfVbSe97zucjJpLkV4ujiYrb+kMUFxV0/FlkWjKF3xkunF6lmoW7Fx7fiKf9/YEAHy9cSMYDAmiQ8rxVCtP/jdtO1O6AUgWJ/LDDgYdiHC0uR/tR3/lMBDTSG7J5B4KrmKDNJO7H8+EE7rhopBZzKU6tP6bCG+7tmmq/HRyLREBu4/swBl1x5ctGAXZ39l25GgZRXZ/24OWuYuJ+uXavPvkUcwm/YAMbRnrTz/MrI75RK2XS5LsADTcSYRQOcvs/IXCC+mPgeadOgNzKRbad7tsRNQJTycu2Pc6rNkTsyaFaBJhacUEZBKd8847sUV5U1tquz/WHzv7rpUHoVrC/ZxgLH2OcPanvSLJExTibVXu+y6z/4bIQPpRWsHvZNMV0H2gM5UhTCwKZVHiTp/gTA/FJeaNCcvWy+7LlJzcxfdicaWurk++F4e7DS36H2FvNBGk8lPK7abKiQfUAr8sazOKtcwLgnLEf8BC94
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003)(38070700021)(5023799004)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 HpRTbrWDnxoktr3tazsaFfxZP2KiohqUIFgjC8noCbHRd892Gbv4AQP/eU+YEWI2zROuvau2VQvPdAI5c5CMWhZ6bFCgX9T5PT5TS+jTPpLitKhO3dPD6iNWpaEc355FidFE1viBww2PKhpudWoj6RnO/xxlP29YmUbTbAeH8MuEg8PiILQsefx2VQkYTaCwVmHp8GOeTE5SQ6g0kkZ1g/oWhw5BtL0If6JXemxlacIIYX1XnJddzKZLqDSYE6P5YZwT+VFtABh4fMoyEfOrNSSd0beva2piVugbDmvT2M1U5MDrBnW245IoyKFXQ9y6iIk7vUlsCQDIUCXGd7DU9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6204
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ffb61684-08be-4387-8209-08deb749fd45
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|36860700016|82310400026|35042699022|1800799024|6133799003|5023799004|11063799006|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	3aTwMfrJqaAac8FpTDM4TX5QE0qjQSS1kUHNDscMmt28WYTduE5QgZaJh4qYnNvWyd6KuzbBS1h9h3QrPiZ1MzO5PFNyRBPdm5l1QhLIrZmn66Gc6V/tubaoT3szc9o1FDBip40gkejvEG8BzsD0srVgFkmy/fBnZVrK5kZEx3EizWv8EozTfJwEPpcepG10NhPdw4G2taJN0mQ8JuFXauICxycAPEub7XYL183NSmUXu8HBLj7TE96dtGfaiX2C6APB6qOrz0YprKy4yd+E24JCeY1jLNHQmoHIwoKQT4AteAOiWvgf6+ITClv2+hLhBwm4IyQubekPi/3PxWeHblR7J6xsmIYFgaNMzAswcl/iFF24utnyg9V3onMfxgFbvYrdEFF4sT0kfwBdfop6JHkQ4VhGKG+yjjap1QJUit9NEHVUrQVwqwPyknuN2VYLjZtQXbjYoG+8C7glhrdWRDoohajz/0mIvOCcBZVYHhnQAp0HAVNJ22otMWsBPAGLoaXFKgsstLl+1IlZcerp3MLU2GW0Q7rd84+N2ulfgxv4xcXRJdXdnQ6ZeqrBdk2nyvm+3oOPzeTUT2Lt1c+RiBRSjguu9aTMaYMKxzkJ34lrnSkNIkkOkfwk2N8EoRjbXcJGI5Oau1j3C81JoX/JEfhLiWPRdyEcgmZQy46v8N/sKjeR53Jp3w5eFi0R1rCB9Mwul3NF6XfRQ8z/+vWwm4zuLxSVYwv+vFUt0sQBWdQ=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(36860700016)(82310400026)(35042699022)(1800799024)(6133799003)(5023799004)(11063799006)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6M+0aOePq9H0kuqK/JkZ/r2yQ2cigmyH12ixfK4MsW+iJmaHm5maEB34rKqdxcnOsuA2kdnMkKKI9cOTUfwtmWjNJWqJvzqQJj7u6peRDW0f2GBqavbixrdJlxwk+2qsNqAdHggEzrExfaGXeFsQW2qdCCqWrbVy1ZV466HoEpBtr1qtB5wz6eJhdDKVBUW8fE690fMDKapbxKp2Oh/Fdh9GRj4qyfFLh7MVmgy2oJTlI7DBlqoA5cQqFb3XdIYSl+9Tx7l2V5vkkZr/eAoYDxtCjqjxmMFo9MyOCTmHbLWUGDMDLPkfjNanty+VB1MTfUyEalGLPTPqP8NIIGdgFSbXHqW9wBnZmAFFrLe16oxyYdiSKkP/1eGfX7engqPXF1lLpE7Z/2dRj1kwEHlygrCD3WUSQmH1mIEzlEgSzdQrqmJ0LaE2YxYpK9gmh80C
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 15:03:36.9851
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2e5b7fc-7d10-446f-4edc-08deb74a22b3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6326

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
restored prior to the IRS_IST_BASER. KVM uses these restored registers
when KVM_DEV_ARM_VGIC_GRP_IST is restored to determine whether a guest
LPI IST exists, how large it must be, and where the guest-provided
migration storage lives. The host LPI IST is allocated and populated
as part of restoring KVM_DEV_ARM_VGIC_GRP_IST.

At this stage the remaining MMIO registers can be restored. The SPI
IST gets extracted from a userspace provided buffer, and is
transferred to the host-allocated SPI IST. The LPI IST is extracted
from guest memory, and is written to the host-allocated LPI IST.

As a general rule, the IRS_*_STATUSR registers can be ignored on
restore. They are not userspace writable.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 0ee0fe9308fc9..188851f22f9eb 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -232,3 +232,48 @@ Groups:
                    or tracking pending interrupts
       -ETIMEDOUT   An IRS save/VM operation timed out
       =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+IRS Save Sequence:
+------------------
+
+The following operations are required when saving the virtual GICv5 IRS:
+
+a) Save the ISTs by issuing KVM_GET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_IS=
T.
+b) Save the IRS MMIO register state by issuing KVM_GET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_IRS_REGS.
+
+These two steps may be performed in either order. However, the guest memor=
y
+must be serialised after the ISTs have been saved, as saving the LPI IST w=
rites
+the IST state back into guest memory.
+
+IRS Restore Sequence:
+---------------------
+
+The following ordering must be followed when restoring the virtual GICv5 a=
nd
+IRS:
+
+a) Create vCPUs.
+b) Provide the IRS base address by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_ADDR
+c) Restore the number of SPIs by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_NR_IRQS.
+d) Initialise the GIC - this sets up the default state and creates the SPI
+   IST - by issuing KVM_SET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_CTRL with
+   KVM_DEV_ARM_VGIC_CTRL_INIT
+e) Restore guest memory.
+f) Restore the IRS MMIO register state by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_IRS_REGS. KVM uses the restored IRS_IST_CFGR and
+   IRS_IST_BASER state to allocate the LPI IST during the following step.
+g) Restore the ISTs by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_IST.
+
+The number of SPIs must be restored before VGIC initialization because
+initialization allocates the SPI state and fixes the SPI range exposed by =
the
+IRS ID registers.
+
+The various ``*_STATUSR`` registers are observational state in the current=
 KVM
+implementation. Userspace may save them for validation or debugging purpos=
es,
+but they are not required as restore input and do not need to be replayed =
during
+restore.
+
+Then vCPUs can be started.
--=20
2.34.1
