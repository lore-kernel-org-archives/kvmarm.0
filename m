Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011070.outbound.protection.outlook.com [52.101.65.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4553C3E8C6F
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.70
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935598; cv=fail; b=C8/qJvPyoxZgYkkm/l66qFsZJYmrwfQNXhBLuxnL4VQywvBeZGI0EH8bIT0ZN1Z3Yyn0Q8WqbVk9IWes3TA+iRcEttXRpAflqAzcyxfy3CFVOy9ZcDUGmbQXfTq2HB4tmYbJbWQNfXK9DGtmp3dPHUJi6gRTDvnZa0DR78RjRKQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935598; c=relaxed/simple;
	bh=NpjbL3z0nJ2umAua0BHF+NRHy6+aVwTCq7OMV66TnYU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MPHRZKuxPoZdPL0iGqgb4P/bMGD69cTwf3ttAdUXXjQ8J7cZFyMCKOo2mYQi0IYvcY3NmeW9AMlYNENJIG48lJH++ppnwFvWte4KnOj3HI0XyHfBrzP4k4TkLKdtgDdXYAL8qPV+5kDbmbnhBcrVgrqjplSV2OBkONqAxS5deAo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DugMIrWu; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DugMIrWu; arc=fail smtp.client-ip=52.101.65.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DugMIrWu";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DugMIrWu"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kzT4OO+JCi0NvvMusN2lsCoXVsYWtP6ooR8afPhY5POvcG0l+ymqV/MjI4GqIkZnwAjBlI6uf6w9bPXalaBATH54nza9GQuXCqCm/Fd2wMoADKNwpk1AyK1UENcdzvGO6EAq+S0L/1CBKOtlaPd0aPAGYZpvvN5y4tBK8txQRYs/WGVpMMXHFYsupZC0K6dgq2AgYchB9XCU8zTDWFmaOtMipuGnC32guuKFt25K6EvajFjEJ6XLL5G1BA832jtr9gCk+Rnad3PhQvCLS8KXNst4T+9WI1/4X1MDKyXAtL6r4Yv9JlWh23BeZE9zJL1Tt5Sxq49Nxu4XTJLS7+53IQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K9arIZqlL6eoJpivsPSdHckqxX/F2sHgcAwMCRZuPNE=;
 b=AwYoHzVlXpAJ/5xSig7NzE4vz1bZGfqknSme7fRdkZjC6TdIQVIutQoPM8rTJMznVC0yMG7YJORn7GcArp1YT5kFlmcuWJQsQE+4EWIu5DVy20YfHlhcP8HuQ+VybR6e++TLTV/+JLTqgDuQFD60ln5MdlvBFfxaqlGgys2iFu3cFOogVvD9cTI1PjZ8QoIV3qdDG5AwK9TnmfL5+aV82M0ln+49WcetMJkeciGC6Wqr2MyN4oBd/O091WAcrDufqDIT5+o6zliWDTDJuRiU16OaatdCjwn7DfE5FKoWc+RbRByAXleGT+fJ5dhp6vmY7rtxqrFIOeLnIw0Cv9ercQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9arIZqlL6eoJpivsPSdHckqxX/F2sHgcAwMCRZuPNE=;
 b=DugMIrWuwp1s7O6lJE5MjrAlH5tKKWlzyYUWN/fkROZvgJR93W+JbFb4fk43HyxF6SlCY3CsSSgnyOBpIE1g6lRTdixYfpyNLar8Is5nV/UA7v5hxC1tD71GAxGCsN7Dy10HnfHwlzHpOWO5NoTC3DoUGjcSlhPIh/f2howc5sE=
Received: from DU7P250CA0015.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:54f::29)
 by PAWPR08MB11204.eurprd08.prod.outlook.com (2603:10a6:102:469::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:53:08 +0000
Received: from DU2PEPF00028D0D.eurprd03.prod.outlook.com
 (2603:10a6:10:54f:cafe::b6) by DU7P250CA0015.outlook.office365.com
 (2603:10a6:10:54f::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 15:53:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0D.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:53:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OCpgHgr5a6hzdhhswjumoSigzubL0b5SO+HSScmOeXGcWm/c0zP7PAfg2UXXxdWNLFGbxGLeZ1r4I1B76TLfOsj6OAr0XwFqmFuM5wIXgjRbonYYtdbFJkhtosJJOhBxGtsep8kLlQe32UU3AbVr484fnZqKCTfw7RT8kfISjF0583FqlRHstI39eYsEwE5kHGOg3xy08NZcMfYoXOfQk0wmcePU0QMjy7vHARssU8eVO48rAIjRWNc1ojDpMy20GXXc1qbBnIn8uFQD7yKGiqzYEex4qXu4Jlf94sPzSKiKB9HvwzAZVL/V4AmNcuMVvQxvQA9vCuGRkuJ9ebSppA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K9arIZqlL6eoJpivsPSdHckqxX/F2sHgcAwMCRZuPNE=;
 b=LLuc3bO32wtFtmZbk6blJ3tkeXektGCbidC1TZ7mYLbKh0i7Pf7M6ffFAyTFM5acud6QcuRupL5YLeyAqQLoGHRYNu5dItCgX8hjd8uKkzLDmP1f2Zrv/t9nd79xflx8JCZEteafZrottHfdnqMPmPGU7GOEck+6uA2ruLBSs8CMu7Z8om5SVUO+7T8MosOPwUN8D64FpEHVyAj4MqNl6OyGQ8QwR5SEi/RqC/2+i/TXMyTra3+sXponzFD7yicyjwjc+ujeibIzZ+Oiz/OsGmkUshtGfzHKfHkIftXb0fyBHyHfr/ojQv5EQ58OxtOqxMQpzNwvrtk3f4VGHKD94g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9arIZqlL6eoJpivsPSdHckqxX/F2sHgcAwMCRZuPNE=;
 b=DugMIrWuwp1s7O6lJE5MjrAlH5tKKWlzyYUWN/fkROZvgJR93W+JbFb4fk43HyxF6SlCY3CsSSgnyOBpIE1g6lRTdixYfpyNLar8Is5nV/UA7v5hxC1tD71GAxGCsN7Dy10HnfHwlzHpOWO5NoTC3DoUGjcSlhPIh/f2howc5sE=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by AS2PR08MB10250.eurprd08.prod.outlook.com (2603:10a6:20b:641::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:52:03 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:52:03 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v7 09/41] KVM: arm64: gic: Introduce interrupt type helpers
Thread-Topic: [PATCH v7 09/41] KVM: arm64: gic: Introduce interrupt type
 helpers
Thread-Index: AQHct7hUCO/Koc+Ib02yTgljBXqphw==
Date: Thu, 19 Mar 2026 15:52:03 +0000
Message-ID: <20260319154937.3619520-10-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|AS2PR08MB10250:EE_|DU2PEPF00028D0D:EE_|PAWPR08MB11204:EE_
X-MS-Office365-Filtering-Correlation-Id: 3da6f82f-62ab-4c26-d7c3-08de85cf9d91
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 LfU3wf5MRXlxYMfjOtdy12KI1C0JKB5k35iLwU5ADKcwvI8V1MN7kPhSlNuyBDbUqyjvPUGQvvI7yHViyUba+in146Hj8QeGeKoGW0r7eLnm4xfvyRHP8qYZNn0eYTfmL3ijQxYbCxZbhmbEIBMXHb/Lp2MgT4Gd9k9RKqI85ddCuKZ0gLfBb6kzXZnLFyo7ojt7GjhVUMirW2yPrvzjZ+P6rMBfO97W+cdoZ3Ked44+sG++Q7L+VRYQpqJOXK8bjZqTHofyiypKAVfpZrcLg2CgR6GBGifSh+ASAqwTlgCHiqsVRlGT9CfBUWnGIc4HRRAy1cy6VKxVRnwY3Wp43OFFjPEje5b76LmVShGRh4iMXVDASyseWHPjXuxtTIP5jgqBm6fIML5EsYswrzEHtUjSF87Slt94buNRuCN+EDHajnoCv32u7fFYJSqDAoEY8fnLCQOrZlOwtHdL/AwHjJ+dH8CQn00EYf5ywktw10C8qmmqTd0foSR9QrZpf9buDqC2bxBqIPdb6VovkKVHpW6KnIZILwAxI9uR8Iaznqsv7coY26IVRJC4+SDEIVgv83rZq0OTxyVwPjDGGEzLuj6R1Cj316hZutQP0w9C0BXIpNIX69mEIJvxgfXPKO1SuJLVUQm/tty8WcM8ZWdCOyH4IgvdhI23HSA72pPjSIQpnW3fcTIE86+T5JuDisDmtPQCLFahsqOpWE1IumFmMOxNuUWTEzwC57nEybjUWgrTnFyRomUyMdjQEiB4rL23A5rBS7Fu3s6K5uKvs0z9qepkOYsUorRs2wNjPSQniaA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 qb+B77hTKHUt5XQzZrDLJO8NEWJzy3DrQD0Mp37tDigPTf22X+RDFBOTzu6N1UsG8426+pHjhk1F6W/2RKVLjgc1mlhNvkg/0IIgBYt/7QT0Ja9RITQM7Z1T33XnUAXs4c8cuJDco59gGs2FPHGR6sQuN6zM+9OIUzT8+sIwFFwmKsUoeLRVPXf6WrwAkKi/+dpECEo2S0GSxHNnPi4KnY7J4uLGTTJr17/NMFIFgEDQF7KWqPFcMymJL+Yim0Wslhzkh6hUFnGFKG0p2ZyJa48frC48L1giKv4JgFygjzdOlMmSfjanPTTkYK4G3/DXPyQVU/jkN2nbsx1+2xq1YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0D.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6683516e-2eb1-475c-87f0-08de85cf7710
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|82310400026|1800799024|376014|14060799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	FowNFgk4J0ucQRTf/nRW1U+pk+j+kmUpAB9UlOe3cketOifDWzKKuZ0WEfG0V9QLhCeCRpEBe53fMtN2DW5l3/k69atalOeVBLmbb+qrKrobR+GCZZrxPxE8T6Wu3acnhclT1ScJQM7bfGYPS5XdM74l9nYDL3dWggSVEbttAcP56saCEjKk4rmtFrR42iXddz447QbGnThqeYeDa9IF3/FjwBMVSMu4M9m+1Bby0DBOPkS2VGQk+hFfm5qx3rfuGPGtwMynob2jSg2UdpG7Ft2YkwHGKQEjFr63nwLXvq7xnw1weqGfmsV6s8LaHGQisSjXnNFLo5GtrwiIVVXz3D9w4DLlwMfQ8klfw6U/IvD1U4Drp42RIyRS/PoPvNvhhhpZ8o2Q2vQY53pZ+0LXGDySTsQCtEawF1sMjSsLGAYpYTC8vr4Djr9o+KvQffMTD6hGALxohm826LRARz7lHijbsKpzQxA1r0S2xkqXQKj4Vd+GmV309zOYbk/FdKcT/RsEi4pWk1915ioVYZASRmrBP+X7ryzCLkOw7jY4fa9T5MqJIjfkFAAUnXeZ9zquLEC4eDfLcw8bWx5myvfCSttaMGjgGQMM1DJ+rKvxHb0V8EopO+PbX4+/2L8088jYYiTu5H31u5g0Kyigi9qLIdvcAmv9HOVVxcY9zY7TKsnzJ2ffjKkv7IiXnklwRmyF/l2Fgt1Nu4x+K5E2+6S1Drz4S9PUWDwWfwGnKDXt03bqZEm/ew/vZtF2kHRL9l6XfMW9VyeLUGz5xehEQPj84w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(82310400026)(1800799024)(376014)(14060799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	h5K8+KBhVmfScPQBHW7x4+TgWGNnxycMK/7P6tmxMezzA4Te2nLGvDwapRHFE0KuBYSBfqgOlBMpk5LeZpWWlv7ChfmnSEW+8e2bU4CCsmwLejHwl8ouGKWhRykLwI3To0qi/a3XRGpYKqZBl3ccVHHJEfm9Gp2FTw5rhwNWSitLQ6WiZjvB5ToJ9Zqb6PUGqQCKltl/jcCLPEtNiueHtgqz6gusu9tjaUDBjHOWTVV7JtBv0DY236VDUE+IoZ4X0R5UUhxKOuxblVw3tdByzHpCpMAZGI1iqMPw0iV2Jqntb5CuULc4P8ijhMdVrs7Tzb/HYrNNHGZaQnZrgsa5hSAj++GbVT7i+pROolgJyNGN+EeMmxYhBFLmhoanRkXmk484VAAWD+ijmI/n2s/B9CF16LBRsdWhSvX+RQQB2BnCbvrtKa0/VaabSonkMyYT
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:53:08.0415
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3da6f82f-62ab-4c26-d7c3-08de85cf9d91
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0D.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11204

GICv5 has moved from using interrupt ranges for different interrupt
types to using some of the upper bits of the interrupt ID to denote
the interrupt type. This is not compatible with older GICs (which rely
on ranges of interrupts to determine the type), and hence a set of
helpers is introduced. These helpers take a struct kvm*, and use the
vgic model to determine how to interpret the interrupt ID.

Helpers are introduced for PPIs, SPIs, and LPIs. Additionally, a
helper is introduced to determine if an interrupt is private - SGIs
and PPIs for older GICs, and PPIs only for GICv5.

Additionally, vgic_is_v5() is introduced (which unsurpisingly returns
true when running a GICv5 guest), and the existing vgic_is_v3() check
is moved from vgic.h to arm_vgic.h (to live alongside the vgic_is_v5()
one), and has been converted into a macro.

The helpers are plumbed into the core vgic code, as well as the Arch
Timer and PMU code.

There should be no functional changes as part of this change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/arch_timer.c           |   2 +-
 arch/arm64/kvm/pmu-emul.c             |   7 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c |   2 +-
 arch/arm64/kvm/vgic/vgic.c            |  14 ++--
 arch/arm64/kvm/vgic/vgic.h            |   5 --
 include/kvm/arm_vgic.h                | 102 ++++++++++++++++++++++++--
 6 files changed, 110 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index dcdb1726e8358..ef9a3df507ee1 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1605,7 +1605,7 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, str=
uct kvm_device_attr *attr)
 	if (get_user(irq, uaddr))
 		return -EFAULT;
=20
-	if (!(irq_is_ppi(irq)))
+	if (!(irq_is_ppi(vcpu->kvm, irq)))
 		return -EINVAL;
=20
 	mutex_lock(&vcpu->kvm->arch.config_lock);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 93cc9bbb5cecd..41a3c5dc2bcac 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -939,7 +939,8 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 		 * number against the dimensions of the vgic and make sure
 		 * it's valid.
 		 */
-		if (!irq_is_ppi(irq) && !vgic_valid_spi(vcpu->kvm, irq))
+		if (!irq_is_ppi(vcpu->kvm, irq) &&
+		    !vgic_valid_spi(vcpu->kvm, irq))
 			return -EINVAL;
 	} else if (kvm_arm_pmu_irq_initialized(vcpu)) {
 		   return -EINVAL;
@@ -991,7 +992,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
 			continue;
=20
-		if (irq_is_ppi(irq)) {
+		if (irq_is_ppi(vcpu->kvm, irq)) {
 			if (vcpu->arch.pmu.irq_num !=3D irq)
 				return false;
 		} else {
@@ -1142,7 +1143,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, st=
ruct kvm_device_attr *attr)
 			return -EFAULT;
=20
 		/* The PMU overflow interrupt can be a PPI or a valid SPI. */
-		if (!(irq_is_ppi(irq) || irq_is_spi(irq)))
+		if (!(irq_is_ppi(vcpu->kvm, irq) || irq_is_spi(vcpu->kvm, irq)))
 			return -EINVAL;
=20
 		if (!pmu_irq_is_valid(kvm, irq))
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 3d1a776b716d7..b12ba99a423e5 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -639,7 +639,7 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 		if (vgic_initialized(dev->kvm))
 			return -EBUSY;
=20
-		if (!irq_is_ppi(val))
+		if (!irq_is_ppi(dev->kvm, val))
 			return -EINVAL;
=20
 		dev->kvm->arch.vgic.mi_intid =3D val;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 9e0d26348a2a1..2f3f892cbddc2 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -94,7 +94,7 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 	}
=20
 	/* LPIs */
-	if (intid >=3D VGIC_MIN_LPI)
+	if (irq_is_lpi(kvm, intid))
 		return vgic_get_lpi(kvm, intid);
=20
 	return NULL;
@@ -123,7 +123,7 @@ static void vgic_release_lpi_locked(struct vgic_dist *d=
ist, struct vgic_irq *irq
=20
 static __must_check bool __vgic_put_irq(struct kvm *kvm, struct vgic_irq *=
irq)
 {
-	if (irq->intid < VGIC_MIN_LPI)
+	if (!irq_is_lpi(kvm, irq->intid))
 		return false;
=20
 	return refcount_dec_and_test(&irq->refcount);
@@ -148,7 +148,7 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq=
)
 	 * Acquire/release it early on lockdep kernels to make locking issues
 	 * in rare release paths a bit more obvious.
 	 */
-	if (IS_ENABLED(CONFIG_LOCKDEP) && irq->intid >=3D VGIC_MIN_LPI) {
+	if (IS_ENABLED(CONFIG_LOCKDEP) && irq_is_lpi(kvm, irq->intid)) {
 		guard(spinlock_irqsave)(&dist->lpi_xa.xa_lock);
 	}
=20
@@ -186,7 +186,7 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 	raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
=20
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
-		if (irq->intid >=3D VGIC_MIN_LPI) {
+		if (irq_is_lpi(vcpu->kvm, irq->intid)) {
 			raw_spin_lock(&irq->irq_lock);
 			list_del(&irq->ap_list);
 			irq->vcpu =3D NULL;
@@ -521,12 +521,12 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_v=
cpu *vcpu,
 	if (ret)
 		return ret;
=20
-	if (!vcpu && intid < VGIC_NR_PRIVATE_IRQS)
+	if (!vcpu && irq_is_private(kvm, intid))
 		return -EINVAL;
=20
 	trace_vgic_update_irq_pending(vcpu ? vcpu->vcpu_idx : 0, intid, level);
=20
-	if (intid < VGIC_NR_PRIVATE_IRQS)
+	if (irq_is_private(kvm, intid))
 		irq =3D vgic_get_vcpu_irq(vcpu, intid);
 	else
 		irq =3D vgic_get_irq(kvm, intid);
@@ -700,7 +700,7 @@ int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned =
int intid, void *owner)
 		return -EAGAIN;
=20
 	/* SGIs and LPIs cannot be wired up to any device */
-	if (!irq_is_ppi(intid) && !vgic_valid_spi(vcpu->kvm, intid))
+	if (!irq_is_ppi(vcpu->kvm, intid) && !vgic_valid_spi(vcpu->kvm, intid))
 		return -EINVAL;
=20
 	irq =3D vgic_get_vcpu_irq(vcpu, intid);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 0bb8fa10bb4ef..f2924f8211974 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -454,11 +454,6 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu);
 void vgic_v3_nested_update_mi(struct kvm_vcpu *vcpu);
=20
-static inline bool vgic_is_v3(struct kvm *kvm)
-{
-	return kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3;
-}
-
 static inline bool vgic_host_has_gicv3(void)
 {
 	/*
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 46262d1433bca..b8011b395796d 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -19,6 +19,7 @@
 #include <linux/jump_label.h>
=20
 #include <linux/irqchip/arm-gic-v4.h>
+#include <linux/irqchip/arm-gic-v5.h>
=20
 #define VGIC_V3_MAX_CPUS	512
 #define VGIC_V2_MAX_CPUS	8
@@ -31,9 +32,88 @@
 #define VGIC_MIN_LPI		8192
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
=20
-#define irq_is_ppi(irq) ((irq) >=3D VGIC_NR_SGIS && (irq) < VGIC_NR_PRIVAT=
E_IRQS)
-#define irq_is_spi(irq) ((irq) >=3D VGIC_NR_PRIVATE_IRQS && \
-			 (irq) <=3D VGIC_MAX_SPI)
+#define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) =3D=3D (t))
+
+#define __irq_is_sgi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D false;					\
+			break;						\
+		default:						\
+			__ret  =3D (i) < VGIC_NR_SGIS;			\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define __irq_is_ppi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D is_v5_type(GICV5_HWIRQ_TYPE_PPI, (i));	\
+			break;						\
+		default:						\
+			__ret  =3D (i) >=3D VGIC_NR_SGIS;			\
+			__ret &=3D (i) < VGIC_NR_PRIVATE_IRQS;		\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define __irq_is_spi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D is_v5_type(GICV5_HWIRQ_TYPE_SPI, (i));	\
+			break;						\
+		default:						\
+			__ret  =3D (i) <=3D VGIC_MAX_SPI;			\
+			__ret &=3D (i) >=3D VGIC_NR_PRIVATE_IRQS;		\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define __irq_is_lpi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D is_v5_type(GICV5_HWIRQ_TYPE_LPI, (i));	\
+			break;						\
+		default:						\
+			__ret  =3D (i) >=3D 8192;				\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define irq_is_sgi(k, i) __irq_is_sgi((k)->arch.vgic.vgic_model, i)
+#define irq_is_ppi(k, i) __irq_is_ppi((k)->arch.vgic.vgic_model, i)
+#define irq_is_spi(k, i) __irq_is_spi((k)->arch.vgic.vgic_model, i)
+#define irq_is_lpi(k, i) __irq_is_lpi((k)->arch.vgic.vgic_model, i)
+
+#define irq_is_private(k, i) (irq_is_ppi(k, i) || irq_is_sgi(k, i))
+
+#define vgic_v5_get_hwirq_id(x) FIELD_GET(GICV5_HWIRQ_ID, (x))
+#define vgic_v5_set_hwirq_id(x) FIELD_PREP(GICV5_HWIRQ_ID, (x))
+
+#define __vgic_v5_set_type(t) (FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TY=
PE_##t))
+#define vgic_v5_make_ppi(x) (__vgic_v5_set_type(PPI) | vgic_v5_set_hwirq_i=
d(x))
+#define vgic_v5_make_spi(x) (__vgic_v5_set_type(SPI) | vgic_v5_set_hwirq_i=
d(x))
+#define vgic_v5_make_lpi(x) (__vgic_v5_set_type(LPI) | vgic_v5_set_hwirq_i=
d(x))
+
+#define __vgic_is_v(k, v) ((k)->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_A=
RM_VGIC_V##v)
+#define vgic_is_v3(k) (__vgic_is_v(k, 3))
+#define vgic_is_v5(k) (__vgic_is_v(k, 5))
=20
 enum vgic_type {
 	VGIC_V2,		/* Good ol' GICv2 */
@@ -417,8 +497,20 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu);
=20
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
-#define vgic_valid_spi(k, i)	(((i) >=3D VGIC_NR_PRIVATE_IRQS) && \
-			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
+#define vgic_valid_spi(k, i)						\
+	({								\
+		bool __ret =3D irq_is_spi(k, i);				\
+									\
+		switch ((k)->arch.vgic.vgic_model) {			\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret &=3D FIELD_GET(GICV5_HWIRQ_ID, i) < (k)->arch.vgic.nr_spis; \
+			break;						\
+		default:						\
+			__ret &=3D (i) < ((k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS); \
+		}							\
+									\
+		__ret;							\
+	})
=20
 bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
--=20
2.34.1
