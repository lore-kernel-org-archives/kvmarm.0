Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011035.outbound.protection.outlook.com [52.101.65.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044C212C544
	for <kvmarm@lists.linux.dev>; Thu,  2 Oct 2025 21:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759438820; cv=fail; b=WED+PT4NS9CyW3Jt3SKM+4um99T74fr4KwtadZJT9UPUoZTkCnNqwFsXuJVh6NoDraogDY1H8VpuWP9YMel1feHsc8yybnjBrV9+OA5kMQJwNXoKoZ9dJGGFFQ3urZjqWLYYpB1fwOv+Ctf97jzXyyWfigebArC8EB8Nmrlwe8Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759438820; c=relaxed/simple;
	bh=01TWKXTiACtb3nV8reVz8dZr3TqCL8vueP4PGX100iE=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=jup61yNNEneqcmrnobcmS9D+tPRMIJt1jmeyqtBPWyODRhPuedVrTlYoINYVwZkqHdia+tDKx6FfQaKz5LakOHNV1eAuPvRPK6xGMdDyhMwgu4hVdsjW0Nlu0W+rQMlxPoAB6n0iRz866O8Z0odse8Z4jmOXMoALNCNTWNZUkFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com; spf=pass smtp.mailfrom=epam.com; dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b=Tb3nN34q; arc=fail smtp.client-ip=52.101.65.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=epam.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b="Tb3nN34q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VsIbknF218g4aTbWOUldZS4xXow1d1y3Idj3C85gTJfyTCrZNbYJyqAFgsDw6D1I3z9jjqa233wWUnZzQr7llyLT8ibR92diRQeoVgnCDWFQB30IakhOPkXYJ3kKfoQA80GrX/CzLbaVkSvvX/OKXF4PjzZdoOmMPHpTveEM533smpR45sorNas2HnLPkRaFYKYRJccGIG5IM1KdBLqgUX4bg7BjktYqDbMaVTltonI/uycpo5xpOSgJNJiE2B7XaZSz8niFkA+WkionU9EIq7A9NVHiTCGSjjxD4bQXxjyYRBsXt/E7bFdTGhBy9I3I0biuxYRCpYpQmCnVc00qFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sBQnYdmxHeZtXNSVglOMgNzHHmFGQAH2W/Xo6t+c6rQ=;
 b=Z3VnmjoW7Civ2zJ2PdoKiW78W5l5ktpqRqlQ9IsM/HkWnwlNecpkFia/wj7nevmGccFWLpwGPDn1t8oiP/JbEIqp57Dpi5lJi3XmCbRAzlOPa/jcNeoohP18Ni43ZwYH5spmR70YaUdbc1DuBaimtjHoT6RPIZ5RuaSveZZE3DL8DvwZgQkKjIbfJzUuQtPaKrgCLjY1+8qmwWpLNJmmlUHRepwpDddmM4e4kph8Fpg6MCW5/o3GMgvCHa0zgmQ6GllDlzoyvjAHVNh4RDQi5s1e39FXwS5YaU1224LmgrDnBMSyKkE92WdOkxP51N/MDlVAbXXGdjvk5Os/sRdPww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBQnYdmxHeZtXNSVglOMgNzHHmFGQAH2W/Xo6t+c6rQ=;
 b=Tb3nN34qWMQrH5NGdFw5rg2qE/s1Qx7UyiE/ysvMSK0MrTT5rDKdsS6RXFNzw62vLCH2GenuwjURUIGYPZz38IqMHVvsB9BjuPtoO0yNduNsMacRPuuoubRkZYRIs/fN25hswJ+SPOX1cwwQsIL7r7Jy6KYOMLiCr5htd6AtSlmku46myAk9Rz8IP+IkKFp6Uu+qjIlnWrgEGRH3I3cYGlYnHqh1pcgTb5TUjW5GUp+lcePKIG0FUDrwY6rASnFZR4UuPZSLhmaFxZoxc2RACzBE92Y2QE7ZzLH0go5noGIekS29WZYqc9uF+Kk5i9A2RTQkZtAtdOqlR2Kq6Xfdmw==
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 (2603:10a6:150:16a::21) by VI2PR03MB10666.eurprd03.prod.outlook.com
 (2603:10a6:800:27d::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Thu, 2 Oct
 2025 21:00:12 +0000
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e]) by GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e%7]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 21:00:12 +0000
From: Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>, Marc Zyngier
	<maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Joey Gouly
	<joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Christoffer Dall <christoffer.dall@arm.com>, Alok Tiwari
	<alok.a.tiwari@oracle.com>
Subject: [PATCH] KVM: arm64: nv: do not inject L2-bound IRQs to L1 hypervisor
Thread-Topic: [PATCH] KVM: arm64: nv: do not inject L2-bound IRQs to L1
 hypervisor
Thread-Index: AQHcM9+LYDnAyTjoxEGPXCTCBBWLLw==
Date: Thu, 2 Oct 2025 21:00:11 +0000
Message-ID: <20251002205939.1219901-1-volodymyr_babchuk@epam.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.50.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=epam.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GV1PR03MB10456:EE_|VI2PR03MB10666:EE_
x-ms-office365-filtering-correlation-id: f62cb07a-b7fd-4e12-37bf-08de01f6adaa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|42112799006|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?UE3iR3EI107dgJU4jtKnyp1qm+1baA+Q76zEXniHC1lpOqTSXaCxW2GUHk?=
 =?iso-8859-1?Q?vTWlWP/zQIKxH44Xa/rxmpGG92U7eyIJ903NzAWokyVAduZ69+SBJqYmQQ?=
 =?iso-8859-1?Q?wH6NzkxnmCV2l41KHy3f1UrhI5vToA1QztpJxvtCB4+kCEnXqj26VTPzsa?=
 =?iso-8859-1?Q?mS+hxudB4zewOD7Jy+3GXsyeg/sDN0fXINI12n63qxkUh03CAF3m91g4uq?=
 =?iso-8859-1?Q?avy++kO6lSJIzfg2VOyNZg4cd1mEut7oGgy93WekgrnzstiKbP9Vb5/ISt?=
 =?iso-8859-1?Q?1kXQmDx59ddfhxCNM6rmXCYmsTNVpTqmmtzAzcEfBFrEw5Qyw4JU9wTUJX?=
 =?iso-8859-1?Q?m2XS3MUEK7yA5AHpqnGoclo1VQMNo1VAay4cIJhSjekxGrp4NTfNMKJALz?=
 =?iso-8859-1?Q?KrljwH8hLoNoc0dd1nMNjlon4t9kwPGWDj1b1EE7HGuK5o4fPaELvSI0kJ?=
 =?iso-8859-1?Q?pqmnSgJVjmMgrTc/SNmroSgA4bxS8kIbmcLGkW7sJ9UPAVKpy6wsaBvLFL?=
 =?iso-8859-1?Q?qnR9U1hZDgU6EfyipD3MejeWOiybUA2bBuOnl95ubwBGgJv2Hm/dl9J+KZ?=
 =?iso-8859-1?Q?RroPrzhuWnInmREmdjAX6QHni00TvvvgGgeqowr5EIyv5SKr0K7JGZiJzl?=
 =?iso-8859-1?Q?JtXR5BZvnulOwIpgg84wcGIKu0UwbK2/UNHOdHiAIy5uK2R/JOn+m9APpe?=
 =?iso-8859-1?Q?RAFcxt5xYHvL4CG6Uycb5Yz6eYdBinuGyU1JkyJD+pXgSEYvhUmdWA9Bkz?=
 =?iso-8859-1?Q?h6yaSZtKVdZ/6LDv/03OXd3C6CUP3oQpNIC/D/ZQkpsvOmQvyg7H4qPQsH?=
 =?iso-8859-1?Q?OpVpGX47iX1ehvPtNJa3BYF21FN/U8bv3h1VTNGXu+Kui0bU0JLohZhrfr?=
 =?iso-8859-1?Q?s7Di/8iQylKcHbc44vKjYNHtwcDtZxr8rZ2Eoo4cVPF0/QXl4rLhvQijWw?=
 =?iso-8859-1?Q?1L+It1H7c+1pkdsT4PwDNS+zfJC/iD8/GVDs2T5hWc9Xpu+SuiezBh8/Gy?=
 =?iso-8859-1?Q?4Z6Cl4bSpabLEJVjLQhecOw33ub9hNfACh/BBtp+CsJ+TwrFtZqHzz5p3Z?=
 =?iso-8859-1?Q?cGxh+XO7R/j4AesehzGbq7WojkRqu7qKkg+1gR0B8/1tWwSCAaqShl00kM?=
 =?iso-8859-1?Q?JKmMz3Ajx45+JFIL/5rWPtqrBQNkHFeG98Syn1cH7NAr3x29cziZ2XiCOZ?=
 =?iso-8859-1?Q?WvwmCJ7sknhzIJ7n/6dL5JVThLD49Snq9J/vSik4uHS2218R6RYB4dtU/V?=
 =?iso-8859-1?Q?AOfzaxleG23UavqOAhY9b0OJBdyCs7yfJT6FIjxfAMAWA+Xat/dAStqGf+?=
 =?iso-8859-1?Q?g7ms3EZq8NvAM9dMoEJxiw56Vm/sPBKMe/hnBTnoUU75ZfFsd+eki51Ftr?=
 =?iso-8859-1?Q?K8PPjh7/c6OFrDlp22YbcbFxFOYY9AmLO67v5VXeJJWkxFxQ8K+OWd84ET?=
 =?iso-8859-1?Q?g4S87gI3NawQtnHrJ8SNtgJlX3uUwdc82MjqvptB5VyZEtB0kXifO4JqBy?=
 =?iso-8859-1?Q?xsurDMVr7i5MCzKTfHbP7ic+EdGgdSbyUe/McePohPjPDxQIlxRaidCQIe?=
 =?iso-8859-1?Q?4CCOCV1dr3PIHz1kHtUub8ydFhPs?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR03MB10456.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(42112799006)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?hFKX4hEw5fV8GzwiSI/aRLpYc0jSQU/VNpBA8FZS5V7s0Xkzm1i924Z4Qu?=
 =?iso-8859-1?Q?6k1okL19XNtWheH3P3ip9rdkqF7hj0oUHG88owfeEovlATjM863yvlTR4O?=
 =?iso-8859-1?Q?0vOQMwDBeXbQmK5qiMDJxXLmeOmIPmVDgGATZNuEHNfyu6EBQjJpJg5B/1?=
 =?iso-8859-1?Q?arv56oU58mDtJ4JWApDRNUhdpvkMjY28sgm2r5U0uY/pKtWSxOiA+ILj2P?=
 =?iso-8859-1?Q?fJp9sPPi4V1Nl4NM8uGPW85t/3a81urIVcjah6pYpShs1NAKYMLP6bjBaf?=
 =?iso-8859-1?Q?PStKhr2XYYiJSHjDYD+uprQz1im7S9Chm4z2tysYz7IDvE6rWu9P7PDabC?=
 =?iso-8859-1?Q?qsKcjCRYYpf9gVhc30LB247SGtVbPPU8BNXxInhWtOJNb6aCAWzX3iCPFu?=
 =?iso-8859-1?Q?C1B/8/P8ola4P8ND26t9UXMc7+KsjEEUOVdltKmbOapjqYEIN3rQdjVM/T?=
 =?iso-8859-1?Q?b7t5RMjwWhY1zHFdUC3Kct1nUuvIlah7i8/+IUhu4ZMka/40AgKih4pTzj?=
 =?iso-8859-1?Q?FIBzpiJlEQzmPrWqW/DluE3B6MQlg0EwXPcqbWoSvPS2FqTWnIGJC5eLjh?=
 =?iso-8859-1?Q?emS8OFWKuzQHX/D/GjPTA30w5uMccXRBR3/RKZAN+eYvJyVZRMHIbyRd2W?=
 =?iso-8859-1?Q?CvRU/QF1yNjsYJtyXF9+iWHqw8Tbs0KDC2Xk63zMZwiudcK+pNqIn31DGe?=
 =?iso-8859-1?Q?rb6vCtkCCNSjBW+hI5AxSSH29sK8kKkCLUv/rGeuEQt64BcVpdtk6z222d?=
 =?iso-8859-1?Q?5WPqIk0TKzEX5wdU9Znu3MClV++rEWrCtFB3OXV1Al522WBWhBj4kUlFDY?=
 =?iso-8859-1?Q?3D6t95uIoicl/fqFFbwTOG5ZFzkURcP9vHTVh070nX2OiGGMosEPTSw9AG?=
 =?iso-8859-1?Q?1P9txZ998wly1XZ27p3WZEck3OOi/K6IT0h93d7hsBT6lgjehrFDwY+20g?=
 =?iso-8859-1?Q?E2cLya1ZxxyG+gIJzNlgZmEmy648468qUJE2gx1VRfct37rcbT103syrJI?=
 =?iso-8859-1?Q?lqd6YVUcGMBdxPhvBfVmX9q1clayZYjB0Rsj0ZNghbXETJ7BCyVFWdNN0G?=
 =?iso-8859-1?Q?CPx3dGcGfgXkevQ0L92uu7+pCVdJcQ5RvF+00aKcZqI4xHGbvlLqySnquP?=
 =?iso-8859-1?Q?RMEN0pFnMfy93W03QmCja4lBrQykBCbPH8e5bX71W1DUlzWGYhUMB+9VW9?=
 =?iso-8859-1?Q?OAxPLQGonHj5LKGxCjZkyS7VGnRldvMm77igW3Kbp+VmvxuoPD6nsyvw7x?=
 =?iso-8859-1?Q?Yuh9XwySDFyLqj3D1P4WKtPgHAi3GpQ2eDYGJG7uvOw4l8ofVRSbxvnC4P?=
 =?iso-8859-1?Q?kzULJi+3WPr1bpp7qSeX7jLUjFZcSZFayuCdbBqTyWMTE0VhfJQQP16WB1?=
 =?iso-8859-1?Q?hwi/qkeW+XMp0CwPsCo75wCmd19Xu1C/1TNhwsLbyBeLGN7tDez+c4wPhJ?=
 =?iso-8859-1?Q?pq1GORP4VCk9Rgxz51vPUnnr9YxeSZKff6mHAf0aAFdgFJwKjQfj2Qvzzk?=
 =?iso-8859-1?Q?pjP/aP2xkr4hsuUDm9JKRtdUO6TmaxlM6wx+isttPaMO1ODiCeYDtojK98?=
 =?iso-8859-1?Q?v6FIqTtnNFh5Ijnol2gbp6zyvwXgQQB2jHyfij9i8L+8juCSCxSNvy6i5S?=
 =?iso-8859-1?Q?TEXKNcOAOB4dGMLUdg02ZHdE6/bjCBF24ZKorE7o75CdEH2ScXhNagcQ?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR03MB10456.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f62cb07a-b7fd-4e12-37bf-08de01f6adaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2025 21:00:11.9753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pgdQrZmxW536F4kz/BgegB0n2DxFXYTt4Eo8XEh89gDnhcEAabRl+WXq1DbGNL83l712p6/zxkF+hAuf7YG/l3gse1rmDUDMJnsoOYfSCoo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR03MB10666

There is a class of "virtual" HW interrupts: interrupts that generated
by a device model (like QEMU or kvmtool maybe) and thus considered as
hardware ones by L1 hypervisor, but they are not backed by real HW
interrupts. These interrupts are initially targeted to a L1
hypervisor, activated by it and then either are handled by the
hypervisor itself or re-injected to a L2 guest. Usual stuff.

In non-nested case this is perfectly fine: hypervisor can (and will)
activate all pending IRQs at once and then feed them to a guest batch
by batch. Batch size depends on LR count, of course. But in NV case
this causes a problem, as KVM maintains LRs for L1 hypervisor and it
does not remove active entries from LRs in case L1 hypervisor would
wish to deactivate them. L1 hypervisor in turn is waiting for L2 guest
to perform the actual deactivation.

The bug happens when number of active IRQs is equal to LR<n> count.

1. KVM tries to inject one more IRQ to a L1 hypervisor: it
triggers IRQ exception at vEL2 and tries to cram the new IRQ to LRs,
but as all LRs are already used, so the IRQ remains in ap_list

2. L1 hypervisor tries to handle the exception by activating the new
IRQ, but it is not present in LRs, so GIC returns 1023 on IAR1_EL1
read.

3. L1 hypervisor sees that there are no new interrupts and tries ERET
to L2 guest, so the guest would complete its own interrupt handler.

4. KVM still sees pending IRQ for the L1 hypervisor, so GOTO 1.

This particular bug was observed with Xen as L1 hypervisor, QEMU as
device model and lots of virtio-MMIO devices passed-through to DomU.

Difference between nested virtualization and "baremetal" case is that
real GIC can track lots of active interrupts simultaneously, but vGIC
is limited only to 4..16 LRs.

This patch tries to fix this problem by assuming that L1 hypervisor
will not touch any IRQ it already injected to a guest. So, while
processing shadow LRs, we can mark any LR entry with HW bit set as
"targeted to L2" and remove corresponding entry from real LRs while
entering L1 hypervisor. With this approach L1 hypervisor will see only
IRQs that are either pending or active, but not targeted to L2 guest.

Link: https://lists.infradead.org/pipermail/linux-arm-kernel/2025-October/1=
067534.html
Signed-off-by: Volodymyr Babchuk <volodymyr_babchuk@epam.com>

---

This should cover real HW IRQs as well. If such IRQ is passed-through
all the way down to L2 guest, it should be correctly deactivated when
L2 guest writes to EOI. But it will not be deactivated if L1
hypervisor tries to pass it to L2 guest first, but then tries to
deactivate it by itself, because in this case there will be no
corresponding entry in LR<n>. So, we are exception that all L1
hypervisors will be well-behaved. Hence the RFC tag for this patch.
---
 arch/arm64/kvm/vgic/vgic-v3-nested.c |  6 +++++-
 arch/arm64/kvm/vgic/vgic.c           | 11 +++++++++++
 include/kvm/arm_vgic.h               |  1 +
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgi=
c-v3-nested.c
index 7f1259b49c505..bdd1fb78e3682 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -286,9 +286,13 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
 		if (WARN_ON(!irq)) /* Shouldn't happen as we check on load */
 			continue;
=20
+		irq->targets_l2 =3D true;
+
 		lr =3D __gic_v3_get_lr(lr_map_idx_to_shadow_idx(shadow_if, i));
-		if (!(lr & ICH_LR_STATE))
+		if (!(lr & ICH_LR_STATE)) {
 			irq->active =3D false;
+			irq->targets_l2 =3D false;
+		}
=20
 		vgic_put_irq(vcpu->kvm, irq);
 	}
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 6dd5a10081e27..6f6759a74569a 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -858,6 +858,17 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 			break;
 		}
=20
+		/*
+		 * If we are switching to L1 Hypervisor - populate LR with
+		 * IRQs that targeting it especially and are not targeting
+		 * its L2 guest
+		 */
+		if (vcpu_has_nv(vcpu) && !vgic_state_is_nested(vcpu) &&
+		    irq->targets_l2) {
+			raw_spin_unlock(&irq->irq_lock);
+			continue;
+		}
+
 		if (likely(vgic_target_oracle(irq) =3D=3D vcpu)) {
 			vgic_populate_lr(vcpu, irq, count++);
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4000ff16f2957..f3a4561be1ca2 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -145,6 +145,7 @@ struct vgic_irq {
=20
 	bool enabled;
 	bool hw;			/* Tied to HW IRQ */
+	bool targets_l2;		/* (Nesting) Targeted at L2 guest */
 	refcount_t refcount;		/* Used for LPIs */
 	u32 hwintid;			/* HW INTID number */
 	unsigned int host_irq;		/* linux irq corresponding to hwintid */
--=20
2.50.1
