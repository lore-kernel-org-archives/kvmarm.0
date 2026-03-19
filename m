Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012058.outbound.protection.outlook.com [52.101.66.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8223ED103
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935998; cv=fail; b=AIJBRbjuubUJKZZS+uF9WdUni5R2THULWfQJFHvhCxEqx2Gx29nS+tNvSuYS2ejbiPbVIn3nfBRljLTAg/EOwgCjoBhWtTohbk5lwmNhWnjv2v9aAr2o6b0FbKihY3ab7kW5mMzkkmkvQv9N6LpHEKEgPAFFS7eigLNzq/BifHU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935998; c=relaxed/simple;
	bh=MArmME/U96AovsSxZA/+7j12jz7jlzH2mQOzhQaScX0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fkXXoxtc5JYCEo1TpQ36LL67d9O9QYBTkpZluJ366ufO/p7d7MYD3b2HWs/L6OH6ucTsxze9/3C6tL93aa+veFILbwhuWOg6b6lqXzG/NyadhujcnV1a0P4BFTDOh7gxpd/YJUyx5YCWeim5h7r7tTgTIUNZ6IpbjGKH8zVLGZI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=btHJBzOs; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=btHJBzOs; arc=fail smtp.client-ip=52.101.66.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="btHJBzOs";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="btHJBzOs"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ZfVdHKZS6cbCQLhg6RCfU8E9PtT9iBHNS7RktNafXv1gh8sFCg0fmGAoQOFd2hq+a0C24LF7QQxluzYE1ly0NRb+Nbp7h6smya4483MlhdlROlMoa0qIuzjWADM8VGWhO6AECM9RbdUFEOYdn/1oNGtL0wDnZsmGsQcyGQkuPfoLyqKq+BHQG1WTMkKV57ZHhNWC7vWAXYbCI7DZpszcJVa14BZShYvPLIsRUUCuj//bpQzZUlCA+OPBJ6rqmtDn/fQpGFnNTSDLCOuzKwpGRX4zacuuotO2vfAYaw2LFb4k5vDAJ9NLYy9UA8sHK9t2OXVfkWElBOqZUeIs/mmLeg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LITXEriWhPB/sKaD0binpiSMXKTArtqIvU/i8E6f80A=;
 b=Cjiis9vsEXWSjO1R+/771lSN8/TuPkKxPnXXOVpaf8gIdFOhhuzaWSreilNzSRAwwC63zkCQJMZnSz7soTyryzCMIx2FFWGZFgLC29XTwWfeJfRS2sFurKCTa3YDIkLzcyn2NNvxtTd1VQdN4ZcSDdsv537aURrtdwK+msTefnocRroBVELMahDqEr58Dw9Fp3iN2E1mAhq3vHyYwYk2a13Fpw9eZQdrVhP5IjqG8WBrbcYMO0MHKBHORLp2AKuaucifYXLbN2QPYPerNX4pFl6znHg5Nltbnd1f8Kq+TpGMfcpPfMCtd/cQQRlkth2P2mVwqw82v3z+HSpkxLP1rw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LITXEriWhPB/sKaD0binpiSMXKTArtqIvU/i8E6f80A=;
 b=btHJBzOsx8ZADuh7EpQFzb9N/Ow+x4HkE9oFRE3G0el+pY9qNVoigfLHdrSRiYUYgcJJOQCDAybNq7UXuCUS4M2HgnLstheJ3EJzkhR7xK4scENQHgfFBT59Ku22YKeRsnxwD4tKximdlCr+kBw1niTh76o0a9ei4LNFhY8MsoY=
Received: from CWLP265CA0480.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:18a::15)
 by VE1PR08MB5790.eurprd08.prod.outlook.com (2603:10a6:800:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:59:52 +0000
Received: from AMS0EPF00000197.eurprd05.prod.outlook.com
 (2603:10a6:400:18a:cafe::23) by CWLP265CA0480.outlook.office365.com
 (2603:10a6:400:18a::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 15:59:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000197.mail.protection.outlook.com (10.167.16.219) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:59:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wfSOzRTDdrD57RJokYajcV9mUyctT6ExyqsMcoFjkbM21QIA45QDiAYkz1tKitcTcGJfPC4FaeXlPKVuQLvG7256ARbfGjiX9w70yKOxtHjDPvaqgTV53/4odQFETcg3Sns+fEh1yUGW3TSYP7q40pJMriuKTnGriz3jK1FUaXNzTsc9ULL8xsUF93KyEELOxKiWWnYDAB/uE4U705tspZKIRSZbvnAQb9DtfPtbIiKyZhzDfV+aEZb1t5hEp3fA9m87CVJh6pR+YISkkzxniG2dez2+IuiGP5tzpDXSFOy4FuRbMdJWOhw9NP3XYQP6qxUyF4pIFVzCrVcRuJ0cHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LITXEriWhPB/sKaD0binpiSMXKTArtqIvU/i8E6f80A=;
 b=DKxMxv6QRlHBnuBCUw/X44ZQCvQr0xJkTHIxbIjdqqxVbLGIrJQXWUIBhvbMy3o0XRtypQ4tqa7LfoR+ZtZfKV8BYZJ4vWujcd6+4+QfadhdiUE++xUrvPm46Tbo3atzhQKzZzFClHB3D92M7ql+jxcIHRaOgSadNiHtS+E+eDepx1+Gjjjn71cJP20T0GgxrzDWTGOYJnGysiOdWVwdQKmPpYnB8+jeO7pWtkXpXY4zKlxHu/EQ5DMAoo96QtTe4zOpjefdkr5Wz3vsEVUPgVYiPtUnlmLUEl98P23B+Q8bscQmBtHkz0YQr2Wifmmzcs52TCrVtXyc7H5j4y6slA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LITXEriWhPB/sKaD0binpiSMXKTArtqIvU/i8E6f80A=;
 b=btHJBzOsx8ZADuh7EpQFzb9N/Ow+x4HkE9oFRE3G0el+pY9qNVoigfLHdrSRiYUYgcJJOQCDAybNq7UXuCUS4M2HgnLstheJ3EJzkhR7xK4scENQHgfFBT59Ku22YKeRsnxwD4tKximdlCr+kBw1niTh76o0a9ei4LNFhY8MsoY=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DU0PR08MB8345.eurprd08.prod.outlook.com (2603:10a6:10:40b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:58:48 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:58:48 +0000
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
Subject: [PATCH v7 35/41] KVM: arm64: gic-v5: Introduce kvm_arm_vgic_v5_ops
 and register them
Thread-Topic: [PATCH v7 35/41] KVM: arm64: gic-v5: Introduce
 kvm_arm_vgic_v5_ops and register them
Thread-Index: AQHct7lGoDVxeMu+Z0OQtk/RDhpqPQ==
Date: Thu, 19 Mar 2026 15:58:48 +0000
Message-ID: <20260319154937.3619520-36-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|DU0PR08MB8345:EE_|AMS0EPF00000197:EE_|VE1PR08MB5790:EE_
X-MS-Office365-Filtering-Correlation-Id: 59f0bd41-7a14-4516-7bbc-08de85d08e4e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 MT+o5wSuFsRgce40b1KVVKBSv+DuIiRu9EXrn1oF5B9c1rck3Z0qt2EpBJCKfQdvTikmcl/668XjdBOHsUfM++iYLnVsOtQT3srIk3VYshOVto6bDRoXWzVosRn+u+AQgjtdewKYRogsv37kzIQrfmiRGGoMz7r+KFni2xJ8/cn29siEdBrMdyob5SrVAVntUMIzaTF5F5gljnyXp0+G4NXLqdeLEVskKmi3H8Bt1vo3kC4k/bImsjlm9tEKpsPWyhJ08c1UkKaFTHJ5vqh64sQPOJlHT17rIQVOQSWGgcY5dGBUXY5KINSptmDj3MEZQsvSF9PZkpG6hhrQAcM8D9XxTZgfW6cFCdIn3ZPuXYi05lf42SgvzD/4TzRxY4eAxwush5V/cAHUURhkG94O597AHg+KjEfjGJ3PzlV9gCaT9TcURVIUevxpBkWYVsh0iVpihhOndvf/+ZK/dMPACIurgRyjx0Xa5a7cKtVkMu3dAamgfYPeTfnzhiyMQd6Kpy+i8al1WI4sZAnvIzL/w3Tkpk8kHdkx/GevhOs2bQfJ1V8X60ac8ejalFWEvbkJj8DUxAuVOu3Um+g2FGskfOh4aDcx+NNGGHNZ514FbdOtSC7ZDjboHdEkLTeaSTgDIagoOBsKf8ocJtQzl+4J+HbqBD/ZPorZSYAu/tbBh+K9be1HjbZ27QsaE1RgfDg+2v50FRefHuQoMwtFVYXyMWYBmvKEFwQyWheulhdMFm9in9QJsAWh2K8TIz2nh7gMikPe1MFuA1IMdbwwzy+Dx9TquSCfKNmWEfHYh/d3dUE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 YyNc/4aLxaJ3iThX9lRdtvQ6kNjmJFpp0pmeEqls2zO2Nytb8SMoL3j8tI8bVquCwI/k3xwZOj7jjLy4J2XoDSVq3U62dv0rxAxL58FwLIsuUxS1fzErJ5uHFoLil8aQsk/aavaRnDdvg6mjbbz7E3X2XGs01BC5BDpRjC3dlwpt+5jkAs1klchPx5qa+L9Q3ZOIrKqqGyTZMJd05tlZCTiLsk0FM3dckRWqpUwpGxvUdn/dVyX7/sj4PC/RjQsDv3r0tIZEEPzzVkFrlRqMZCW0mxazm6vz33cA+ghdWBd6QLWc39C+vhxCWzAG/dTetTrSC1C3NH6ewIEQp4LRmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8345
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a6d07213-20b3-49b5-cd92-08de85d0688f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|35042699022|36860700016|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	/tBATK8B9dbHlMPp2hiW8ZrqJsKJatlOn99AB5zQa7gfhKVfLLRJ8bLatkBts6s6FzlM07Dx46LnOPeOW0/HSmBUKp5fv9h1m0bkR2iXjxLxKP5VkltHDX0U0olF/++oSoXuyXcsPJw6N0H68OBlviuW0dw1WizUZBQxX/S7t1h582Sc78LESPL20CikxsRZPaMVhLJhl/gqvbyisq+bEImfxIqIRddNKj3PLdYwhRAWuyvRq3fzMC3w2EVOQQJT1fOEv7iQY005DGkjBLHlBK53qgjHgDgkEishHXzAgqnelMwXBc/ogAWNdFiUjWR6RVpOr996w6BLn7Wl7J15br8Ck2bSOR2ztdNsq+q0/WPhHvrCoxu9qC4HPrcRzE3DUsZegwx8GxyIHlrZ4uOo3CVobhgg8dPW4YfLMOvjXSWdSwvZ9A6sRAvW9V2iyxuP9PyDKct0eiGjzbNALQm67C76ilWwQM3fNKeQI7FkIVaYZjh/gfWpjus7DPonAW306xitnlPh8iCdJ/eo/nkh/W2AVadQp59RxeqQz1lP+S6xdZbChiFpgtdAw5HajepiiH9JDFGMGKggNuWxoMcx3a3wpLfUyHAyKzIWfkwh+5x8W1rhgphPJ5OEEmOw0aVoRnbM30nb1vwtXvC17++RCQ7fV2yyrVmJtgxAm2wkf0wo7SEUD/iur7Nqg8x7t+IdVQ6lwcBtfUdgY8njmCjeq7/EUTh3oFVS7JhpI7K1AK43Q8sOfLRuVRmKaczprcseRfAXGJNmMY9goJntdfAHBw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(35042699022)(36860700016)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RkYFkv/cpKhqb7ZYXU6xqYxd4HffgQkJxGwcp7HVroM/MM/RHhScr05H8jSEcF7q6AFcaI+JmOADjzEO0leygp6kKdaZ8eA78XMxKS1bTvyMIF8xiy7JJtm9tWw0qz0nmim/ezv162o6qkXyAqNOfM0ITLvzSDPgbDo/en31MWEb0eeh1fv397K3vF9Aue+HmneyAcAl+LF4OUfrJV/ETrJOJc0UKAYdIkUoEJOoIczVEZ4zYAlpPbrEHxokXUoU8do6rwx36vUIOwkEOAwGx67aX8fOR451MFEtklKwhr9JwTKwCqFbwC3FOq/q8GYF9F+7sAxwaT1YQb/OSI9P6RLlQuXxbp1XxBXANKOaukqcKohhVgs/YURmYzLupFWKaRsFHGn9Yo1yFuvJKNJvb/Wd+YwkaWFTBZPuajWmLyrcIr3TPd/oeRMc/5DJY8bG
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:59:51.9405
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f0bd41-7a14-4516-7bbc-08de85d08e4e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5790

Only the KVM_DEV_ARM_VGIC_GRP_CTRL->KVM_DEV_ARM_VGIC_CTRL_INIT op is
currently supported. All other ops are stubbed out.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 74 +++++++++++++++++++++++++++
 include/linux/kvm_host.h              |  1 +
 2 files changed, 75 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index b12ba99a423e5..772da54c1518b 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -336,6 +336,10 @@ int kvm_register_vgic_device(unsigned long type)
 			break;
 		ret =3D kvm_vgic_register_its_device();
 		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		ret =3D kvm_register_device_ops(&kvm_arm_vgic_v5_ops,
+					      KVM_DEV_TYPE_ARM_VGIC_V5);
+		break;
 	}
=20
 	return ret;
@@ -715,3 +719,73 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops =3D {
 	.get_attr =3D vgic_v3_get_attr,
 	.has_attr =3D vgic_v3_has_attr,
 };
+
+static int vgic_v5_set_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return vgic_set_common_attr(dev, attr);
+		default:
+			return -ENXIO;
+		}
+	default:
+		return -ENXIO;
+	}
+
+}
+
+static int vgic_v5_get_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return vgic_get_common_attr(dev, attr);
+		default:
+			return -ENXIO;
+		}
+	default:
+		return -ENXIO;
+	}
+}
+
+static int vgic_v5_has_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return 0;
+		default:
+			return -ENXIO;
+		}
+	default:
+		return -ENXIO;
+	}
+}
+
+struct kvm_device_ops kvm_arm_vgic_v5_ops =3D {
+	.name =3D "kvm-arm-vgic-v5",
+	.create =3D vgic_create,
+	.destroy =3D vgic_destroy,
+	.set_attr =3D vgic_v5_set_attr,
+	.get_attr =3D vgic_v5_get_attr,
+	.has_attr =3D vgic_v5_has_attr,
+};
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6b76e7a6f4c22..779d9ed85cbfd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2366,6 +2366,7 @@ void kvm_unregister_device_ops(u32 type);
 extern struct kvm_device_ops kvm_mpic_ops;
 extern struct kvm_device_ops kvm_arm_vgic_v2_ops;
 extern struct kvm_device_ops kvm_arm_vgic_v3_ops;
+extern struct kvm_device_ops kvm_arm_vgic_v5_ops;
=20
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
=20
--=20
2.34.1
