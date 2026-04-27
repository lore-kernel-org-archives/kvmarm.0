Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010019.outbound.protection.outlook.com [52.101.69.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5E0348883
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.19
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306910; cv=fail; b=lseJjfL47x5JDUAnn57UuFJFLGlf1O3aFIqa+cpsgHLJIBnuY+6nBPEP86r7bdcsJQftqRhVIwSz5UfZrKuCxdxiYzI/5oO9Y19UfkiPsl47JwL4l3r9c4N1yDwIwRHZ9ZPV07mPbEGRqHaX2KcVWPVS213gDL5lpuwp1DL5HgU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306910; c=relaxed/simple;
	bh=Ym30s+IETVttcfQEi/17lmrjUX4lw9MzoHpkpLp0dWo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XICIPwXpxqFbjtafEnAnnLNb/pcgDIS96aqRUO1xoh0VfcWVy6Shl4Ft59dJeeqdSk+E35UdeJ9QHuo0iHqWv3QTK1P4y5suaFtO3kxoQuu32YjD+meWqacKjAtb+JRambB5dkvUkp9yj5k3QWg3n/KKHYiL3HQBCuwC+vPqNoo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EkMA/Eft; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EkMA/Eft; arc=fail smtp.client-ip=52.101.69.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EkMA/Eft";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EkMA/Eft"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=OAcVcpEoUqWrp49VUs0Wmx1M1vw48xskFGX/QWo/L7AVk4puMa1GLZvG5XKBc/SspZyXS0L338sO24LAj9BZxbbrlAysnwiFr6DdLuE/5Hgrhs/QZvjrXKV7SKBlEfqwqLFQpijGCo9Lh0/2xadBqciWkM6fTbcNBuxbYpEZl1EWclxmqyBqUCbZPWOEdW0q+wcaMYTtvAb5A8kX4anaFs/mLzGcR7ILbU2UbUV6xmiV1dGt1KwWO48/PCKzDJznlUOSrYKk5EmPkUGGLqBD5RmdIxMeJpP6OVIpnf+Eqqjt37/H9/6GMvOLyqPZ18Vi+5qlr7OJ3Sb0KN3xnZiEkw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mtmv4EI4yiFNkr2cedjvZ+Hq3ExX4pf/C3S/GL512uM=;
 b=PbjiBxyx1E0iV7BTlwJRI2Afod5/ItrCKKS57ZeLrc2AHq/4jTDXdT8nMhDDdBPa6+BK8Rf/puyVekAZTjkM/QSOeaF2z9jBHBvt8JSiPZpbZhUonoM0WsYr7asT0ZhbmnzmDAMaAE+kUqIoM2/fYsRUj/cvu8gmUf40aDY5c+we5qWKkEQAUYUsc7PY2F2mjHloWpTJVPu6qbJFALchLifUuO/hgodEVYrh8gsAXN7Pkn2AbQ59pu7pZASa7acPH6fuGPKqliFb+Ipa69FkrIuQm3rb6X6i4nZMz2drZpHJ0kpGJFhtZs2BxzEyDrC6mox4aagvs9KBeGzSi6gJvg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mtmv4EI4yiFNkr2cedjvZ+Hq3ExX4pf/C3S/GL512uM=;
 b=EkMA/EftA0q3Uad0i0lKEdG3UM4Llr8nSzLe1P6wAHiUvNNjiCbWxMYXtOuf6Q31fW31J5GHxxwiyPj2qmDecE72wiPKacXX2d6/9adaURc0JqqOkMKKMrBs4abjAIQVBSPSc1yB7ji5wOvn07SXYzjswutAGusniCA4jzth9+k=
Received: from DU6P191CA0071.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53e::28)
 by VI1PR08MB5389.eurprd08.prod.outlook.com (2603:10a6:803:137::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:21:41 +0000
Received: from DB5PEPF00014B9F.eurprd02.prod.outlook.com
 (2603:10a6:10:53e:cafe::de) by DU6P191CA0071.outlook.office365.com
 (2603:10a6:10:53e::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:21:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9F.mail.protection.outlook.com (10.167.8.169) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:21:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RB+CzXcGuI6+7lVRiVwL/DCDQ8IRKWIIq5FmsMGpU7jg3qzZ47O96MaxFG19KHNbsdEVlnucO7XeSP2li1UL05FRhLYvTw2sZkMwYh77W/9aitaPqruLszVQfoIarOoiH0lFkjwdjfDPpYzWsZ4Mi+2Sw7pfLKC2CUnIZ7ap0ItlhGt8finIBJj81kB3cT5zK8TKG1DDN+ryGZxvszUFudSpasvVD+uz/TaAxo18EFQyqMPVyGFMA5nRaRb65+ry4zDrExILMlLh96z9GfbL3CoKF7nbHJnb3ezVZCvUMNmsJLIkoyuLnJXPXxYJW3DpeHWegjCwNY15yB2/Zo1WVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mtmv4EI4yiFNkr2cedjvZ+Hq3ExX4pf/C3S/GL512uM=;
 b=yDtiP+6jQ8tWK5fjM39TGRjNLnsezniLhmIa4B77Td8Fa3aVCbQkuTkmekdpqPZje8bpMjtnSk7BYjYuKk3hHmgkStRLeQmffSLMuPK56Bqn1bKozd25LdZY+/CN+CGKQTAg1cCePGjfWzxCVKIS0AXYDKS+knFpONcPHNoVbcMRQLKDVEhyyrBeg6bPyAsnIrnnNtgfiKG/0WSVRsjst7lHzKSE8FgDKnCdVynUmW2Tq7tBceVQ1SzroTVZosQz5nriXQxFUbd53MGDceCW6iu84m90p90rFTx3LVEgX5lAzDeEBzAXTRDX2q3yNxQHaemgqDxkW3RnbVFJSkXFqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mtmv4EI4yiFNkr2cedjvZ+Hq3ExX4pf/C3S/GL512uM=;
 b=EkMA/EftA0q3Uad0i0lKEdG3UM4Llr8nSzLe1P6wAHiUvNNjiCbWxMYXtOuf6Q31fW31J5GHxxwiyPj2qmDecE72wiPKacXX2d6/9adaURc0JqqOkMKKMrBs4abjAIQVBSPSc1yB7ji5wOvn07SXYzjswutAGusniCA4jzth9+k=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by DB8PR08MB5307.eurprd08.prod.outlook.com (2603:10a6:10:114::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:20:37 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:20:37 +0000
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
Subject: [PATCH 42/43] Documentation: KVM: Add docs for
 KVM_DEV_ARM_VGIC_GRP_IST
Thread-Topic: [PATCH 42/43] Documentation: KVM: Add docs for
 KVM_DEV_ARM_VGIC_GRP_IST
Thread-Index: AQHc1mHIzJM6n2lAzUmfrORa2u3AIg==
Date: Mon, 27 Apr 2026 16:20:37 +0000
Message-ID: <20260427160547.3129448-43-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|DB8PR08MB5307:EE_|DB5PEPF00014B9F:EE_|VI1PR08MB5389:EE_
X-MS-Office365-Filtering-Correlation-Id: aec9c133-c7d1-438e-ef40-08dea4791067
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 c+9gwtutkgqb/Ex75+4Nig3swX9NKv1alkbNWLVk53Oa/zaC5p9kh7nSMynXf2epziKI41kpWi9nXlyPR2s/sHJ9Ia+d7vX2SF/T1HfA/0ot8tFMLiVLNXcTwh1zHhx8XJCJoNn1itGdUiqRouC6XNpRa8JSOdH7k95DogqgPgUkS6MeRePo74LMdYjoDeohGKraGC1/4avZYP2uXRiWyrGmDf4qtPtvcqUmUH4QM/McsVnBWm3SgYACVvHg+a/vvWovRj9khfST8hTcaN23hDEOHYtsdsbMfzxo9MCWz0cH5/vfMTypDJHgmsXmc3joqjNjrAkQP458ztqwQkUoCQcnmp87epKAtIAO3OQ+Jbg6Enzt7zPhD7FmP+CPcVNzRkt6GmGHbrfRZK6c4AgJoFx5v9nINDDRx5Pf+v+aHy2qpMeCVPTFbkrICTlcgaXMTwufmpprayDJG0w94ej5VmDzchVc8jeNEqnvM+5koIC0UdsFFLchduxVFydqE992HybwwVypD8eLB4R42fKg0EX/cpuXPLHQy5qwH2fndF2I/aICnSYwFdzkt1s8pDlvHkXgAXFbO+GHBgYIUA+nwyBkTWamdmvN9RVcxWQjtV9TKcYnEzB+Tjgd4E1vqkj6aWw2js1zMFcLeBZlQwuBKC9VgmYbRk8gsszcr/odtC7Zfmbk0Mq+OAK+RDjwY9SDK1GuH6NsWEwlHdtwoANOWzQoNG37dzwOKRyX27zJuwU2Zo4ZauFAQ9/lVbKlhK7oHN0KEjBkkDxfe5a8y/Rlu1Hof8zwwASRTxSijB07Eps=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 ZaDq9zUOrSMrIl1c6dzPWrGy0I9nfd1zBTwf6B3zAJtPDh8kgyV8PsA6S3cWT6mKxOpAnuKHljzCvCOZijNxl7Ed9y7Sart/EadA32xLglQcUa9vGJL4eC8ivydd7gC976EnO5NXhouXf/kBnR+2w8s5r7Swcu52cDbL4Fy0aQYxE65a7terz4qo512o0P8triwRMvH15C1GBkLsXhWXR40NbquDbRRIVkCbRmBeaJxjcbPCArBJWPHe/QEHnfRFI0d/GuxH8Wlpu4M5j43d00+fwsblhkbhYtTdmXd2OoFiMlZLcRIJywmMWNKNedHbXi02X0zh6xVoNSzowuRAZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5307
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9F.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	103b12d5-1d72-431d-bf3d-08dea478eaa3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|35042699022|82310400026|1800799024|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	cliAoSM5/ID6NBrtUcsCLC63OjLfOuia6+hmCFNKRj5t+puz8RlvR51oRRQ+/eLgK0GyqQQAw9E1/4OWaChUPXxYyDmOjUH8kLjZFC/ZacHfi9E6kuhHF12MmjdiaMcj7aB/TmuM1F3Ane2dxqJXihLKbO5LrkJYvpBzeyCIxiFecpMmVFC2FyeVVmU1BrmK6i6uDWMECzJAIt4Wd+t7FgSx8Gjh8YfMM12iNoJKDr2yxf3vSHyT3cq3IYCQjfiQW20oR8EoXbYtZVypArmLld0sdG/fIfLHzQNPBtJZlp/C1HBF6DShho+0gExpev2/4NN1U8ATGKaqR0AVNt0hnZTelZJn1psQRDYVpmpvIKBDXK1oVYg8PDSHEWYMv0w6kV3KVG2LOHB9L/774ACnSF00svkdeXRjELpyzHZ56Ayl47+MyXVhUO2KIselFGL5p88eT5mU5jlNmN01KZoP+R/TjBVfi2eIOpKTuKap59m062NQMwkcrp+CaQRwDUXVJsDkxcxHItzNEGxGUrOMfho69jn5WuG3svoi85j5OmVq6V8RNolqMPCbQXvu66G3DmrZFB95ik0nYFTj7QW6yN3XjpbJFOF9Jpqrpk59R8hhZWrxvtr+UaOV/M1t3jvzu+zSXrDTTxTGsLGbcD5VrLeh4o0Itb0VBcqcsR/yig4r8sQIrxlz5W6jRAu+fLJ+f+/9wHZAPZymsJ87tC3j7v1dE7MMh84AQWwUX6TeQlZkXWm+RL3mpf4aD5a+Hl09vuUrJ9GzM++cWSeANTGQUQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(35042699022)(82310400026)(1800799024)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jjE42QGJPacAEZ1QC+DtH48tbwtyLy7DN67k29XQ3wUO5yk92iV6J5oUuZ/aJAIhdghlGFUatv2E8PqB8T8E2AHLk583n/VEgjIuWxsqph573eM0VpL+m1+EGMAfcAnZPzEqWtwPkjgpp4wdk9TvG3SLSmvMXG7NPurnR92ruT9jH5o49G1/e0APLFMtoiS92wWLdxChveY2bP0CHqLvBgBSXKuhD0Lmb+CabT8RAy+L0FxOGogTevMZgPntKMAodeaMTmEwWmXMjJNNQIpsOa58QL0pgZZystcETkJSpNwKgaafVuC6jXJ/Vog2vachrW7k43I826nATbDYIptStbTitnadEpXZcg8ONOZfW+3xU7LA/rRmB2lAvbM700DuAZxBe9vCTGJ/aB/arNK7Dd4JpbaGeylUxvMD7Aufj0nCFFauFhuTuT5hnhPUl7ar
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:21:40.5371
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aec9c133-c7d1-438e-ef40-08dea4791067
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9F.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5389

Document the IST save/restore userspace interface for the VGICv5
device, KVM_DEV_ARM_VGIC_GRP_IST.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 9fc6afe16154a..38eef7cc63e3e 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -161,3 +161,43 @@ Groups:
              aligned for 64-bit registers
     -EBUSY   one or more VCPUS are running
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+  KVM_DEV_ARM_VGIC_GRP_IST
+    Attributes:
+      This interface is used to either save the state of the IRS's Interru=
pt
+      State Tables (ISTs) or to restore them, by doing either a get or a s=
et,
+      respectively. As part of saving the IST state, the system is also qu=
iesced
+      in order to ensure that there are no in-flight interrupts at the tim=
e of
+      doing so.
+
+      The LPI IST is written to or read from guest-allocated memory, assum=
ing
+      that the guest has provisioned a virtual IST as there is sufficient
+      storage to serialise/unserialise the ISTs into/from guest memory in =
this
+      case. However, there is no such storage present for the SPI IST in g=
uest
+      memory, and hence userspace must provide the storage for these.
+
+      The addr field of kvm_device_attr is used to provide the base addres=
s of
+      an appropriately-sized userspace buffer (32-bits per SPI) which is u=
sed to
+      either write the contents of the SPI IST to or to read it from. The =
number
+      of SPIs can be queried by first inspecting the guest's IRS_IDR5, IRS=
_IDR6,
+      and IRS_IDR7 to determine the number of SPIs that the guest can use.=
 In
+      the case where the guest doesn't use SPIs at all, this address can b=
e
+      omitted, but it is otherwise mandatory for both set and get operatio=
ns via
+      this interface.
+
+    Errors:
+
+      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+      -EBUSY       One or more VCPUs are running, or the save operation fa=
iled
+                   to quiesce the VM
+      -EINVAL      The VM is not valid, or a userspace SPI IST buffer was =
not
+                   supplied when one is required
+      -ENOENT      A userspace SPI IST buffer was supplied, but there is n=
o SPI
+                   IST to serialise/unserialise
+      -EFAULT      Invalid user pointer for attr->addr, or the guest memor=
y
+                   backing the LPI IST could not be accessed
+      -ENXIO       Required per-VM VGICv5/IST backing state is missing or
+                   inconsistent
+      -ENOMEM      Restoring IST state failed while tracking pending inter=
rupts
+      -ETIMEDOUT   An IRS save/VM operation timed out
+      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--=20
2.34.1
