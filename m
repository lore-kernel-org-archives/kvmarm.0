Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013044.outbound.protection.outlook.com [52.101.72.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C606928D8EB
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 14:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754489888; cv=fail; b=UI+p1njVsx0K2H0qY769HRZ9RrZ8vQ+irCd09zv31H349+aLaOpKq6jGrBA/Nut5t3ADbthcKRxB99fhTlMMV8wkGMymH0VK4sXhjRFY4h4NLCQgNoSm5LYV1PEmHTuL3fb0vpzKq6RFBX895jWTKk8ebkmKcrbveIeJk0L93bI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754489888; c=relaxed/simple;
	bh=zEDiocEwBTh1KQwx0S+VQYBU3VJ/UyEfTvs1OCGAQOw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UyiUX1Te3rAcjEL7BBDAmcnUWYTfUEzPovNbKU+YUIqLN1FVuP/gzJM+tXNJg+f53vTSBMCELu6hl7xLskQtPyfw+18XQAca7+SxFdCMqNtn+qPNSpjLP2QS1PmMOLcZ+BRVWPpzPKwbMG2O3XS46Mz29TV/SqWluK5C564Bf3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com; spf=pass smtp.mailfrom=epam.com; dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b=PFlK4T/6; arc=fail smtp.client-ip=52.101.72.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=epam.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b="PFlK4T/6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xuTCLn2UBaIxgmxsze2VE4jzqxjFJ5kJA2azhQzyFGh2UMEJmX6t5QS8O7/Xe++MSaiBKWrUi4/ZE4HD1enD9LjVMAxZkMEhnDHTJhnoPeLd8QbKbQgZNRLNtuepY5bU0QBkruFJyboCxvnz9w9cEJGtn5ZBFNy4UoSKk/G6aObLDkFp76g1+Npq8zwFfcB2Bd+Z3VcOgVgTzEdLFeL+T7yZUM9vECUlqToGMBk8y9iAQVyPn0VcFNqTmNHgBCpdtaVcCRGdA4BxrGcFHNtGzhhKuLYxsIhNSrK4weCmmi4sL9cXvnS/AQYVF4ZQd0xR+gl9ynvb9RKxUIzJ1bE/MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aPNqhp2ZeLAhxVb/ptukObIOmLXgRNPXDKZQs/viGXM=;
 b=AJJ3NAnoJF2P5bDHrgfFU853II/h4knQEsOVboaCqPLAhoiCLjjYeSc4wcBezXpKHUx81YYuFhjQqiXWdSaDcW8QgmEt98I3oDl8emaVC5HQx8Y+zCbc++v4TQTl682RuFrQrcICFVFZuzUZRY7JnBRCNbmR3FIbmfYid2dNg6mgSmoRNp4YF5mhpklCdelUnxELW2HhDdfhaBia+mcOM8uE9gviGK1LPEBfuK/XPROkwAuJKITAUFU5NWgPIfzfjxeKGySY91FzHixOsmFfKco83YrRjgPca7CDsA3SSTS0vWQLWfMxLyoTrwmLmM3Pyw6hWoMrnCdPU1MUjdvqfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aPNqhp2ZeLAhxVb/ptukObIOmLXgRNPXDKZQs/viGXM=;
 b=PFlK4T/6tmthklgwF3LiNEQkLX4eP7KGQbPPC41+BlHOp9IFso5d7/NwbmrgJmteo5cHXH3GfYLsAUwJlv5NeBprsgQQHBXzZgdiqsY1LD59x4zU3F4x/vs4hNTln3fyjC4gAg5Dnw8fSQaBDhvdAvnAj0iUEZQFPl3guuBsMhXMUp5n7VTCXIgq2Ab2e6+y/JapeaMJHhO7Sh8Tnp/LiPOjqctsFqiWo9zrnux9PSd8Pei2aaW67ovzWXCrGEeRjKZT4YlPid4yEd81AxRBo0w715tWA9H3+ewtTVbz2z6Wboh0Ba+fuaJazSqfcU932kXVo2So1NpsCAcTzS9VUw==
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 (2603:10a6:150:16a::21) by GV2PR03MB8803.eurprd03.prod.outlook.com
 (2603:10a6:150:b7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Wed, 6 Aug
 2025 14:17:55 +0000
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e]) by GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e%5]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 14:17:55 +0000
From: Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>, Marc Zyngier
	<maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Joey Gouly
	<joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>
Subject: [PATCH v1 2/2] KVM: arm64: nv: update CPU register PAR_EL1 after 'at
 s*'
Thread-Topic: [PATCH v1 2/2] KVM: arm64: nv: update CPU register PAR_EL1 after
 'at s*'
Thread-Index: AQHcBtznfZx1EzPMhEmSJJRNthoKUw==
Date: Wed, 6 Aug 2025 14:17:55 +0000
Message-ID: <20250806141707.3479194-3-volodymyr_babchuk@epam.com>
References: <20250806141707.3479194-1-volodymyr_babchuk@epam.com>
In-Reply-To: <20250806141707.3479194-1-volodymyr_babchuk@epam.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.50.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=epam.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GV1PR03MB10456:EE_|GV2PR03MB8803:EE_
x-ms-office365-filtering-correlation-id: 5fd5048a-a160-4474-5301-08ddd4f409cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|42112799006|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?UCftlAVPmzB214YyKwE4r4PPt4jeYeZYAmixokfBP6rA2+j0wHuZFa54uP?=
 =?iso-8859-1?Q?C1BbxgljiXS4dIxWYX31gM0sJfI2oubnaXBTrKwE91bCPUQBSicx0pypJT?=
 =?iso-8859-1?Q?JIDFu+LlkEHHK+bwe7nG6QpCj3VvZC1DVAi5+6C53ZLsGzhyDgDpX4qZLE?=
 =?iso-8859-1?Q?HV1WMgWURCAWO2OqeaJPHAnX2vcIlWrV3+rYqZKEmjh3qukDE1SFxDnfDX?=
 =?iso-8859-1?Q?z33FIXHcf2rx1Jyn8t36QDrJBL6t/6iy0kyh7bgwDmTcvbpoxCAh1DZ0RM?=
 =?iso-8859-1?Q?vDyK7MGrQmSdmXqokqzajZK08Vgft9NUP3e9txA5EdEi8ZozhyeoCcNiwc?=
 =?iso-8859-1?Q?0l0ualELEVtXNx+q9kfQs2dfn5y3aid0qdZL15QNn6GC/uerLYeXjFquTb?=
 =?iso-8859-1?Q?2/dOly3nQoSaEDSV0k9BgtjuzTb/x2LNkXmVh8eN1l+6hjHm/A4FXf3VEb?=
 =?iso-8859-1?Q?KrQSTr6wjkeQ6Rc0jZNigMbiSY9Wzr1LbWGxCo76NfyjtKSSWNnn5aMlcb?=
 =?iso-8859-1?Q?+NuJAEj4hgrsiMfnA0ngYbP8E7nW9iMaNyCf70fJN9S7N/RpIC8p54FTJR?=
 =?iso-8859-1?Q?SMmxsVqlf3zKVf8Uor0+JSEPayn4gdwEpmCyBNmv5e//UMtG1H79rlgkHi?=
 =?iso-8859-1?Q?boLxPdavET3Gdo8iZsOlB0oGGNUqb7DiKd2aWzj6SbJ7q98Jzfw0ivPi9/?=
 =?iso-8859-1?Q?yakOqzSafclYtG8B3iL6ZHtWvycdOfbGBTbaDimxcuE1Gv99jNqHy4gPvm?=
 =?iso-8859-1?Q?OS9acVL26SGmLa63lXD7EoCwX3O80M6fTuWsDGkAY5ctWZT0YPFC6te2iP?=
 =?iso-8859-1?Q?6BmS97MWSTnUA7BFZd/NnjkP7ucuArzmJ+FfZeVuZLJt8+Guf7uMDZrkFr?=
 =?iso-8859-1?Q?MPaWrDQs4wNGPEOvB0i2Asd5WEq/v9ATUgWAkKkbhR3KTCUkLchKYCQe3u?=
 =?iso-8859-1?Q?azKIIeVXcRg2tyueiiTGg2/uLG4GhDN3Oue8r0O+HQwtWPH+SyDQKnQIrz?=
 =?iso-8859-1?Q?iZEtBseaYDt1QuYnlcmPp5qilYzxfodAtc8b+j32i/Cvc7z+G6u3A8pPp1?=
 =?iso-8859-1?Q?CwDuS6gmoAIU4729oP9FcnQbW/Rbk1GsuzTVc7YPcoS4zBa4G5bnkO99T5?=
 =?iso-8859-1?Q?7Kqk3QLz0Hs4gtTcSR68mxXo6TjH2suv+uPI2IbJHqxYpudoBrj3bMR1lb?=
 =?iso-8859-1?Q?TGF2ZMcqQqizRdwnH8ri7iRLmBhNImia1mInVUAxjbJQKsVcvAk8Jky/ux?=
 =?iso-8859-1?Q?IpXgPl/tGZynrMyIgvBRdvfD0BJzpzbHDwo1AG+bqLQwbyZCmafD/w7lsO?=
 =?iso-8859-1?Q?fziabVPY8iusWUKjFPQandxv7R9FXnPsHxdAeEV+ArgNQHzbX43dK98zWH?=
 =?iso-8859-1?Q?sa/uQ3ETv/DgX9F2Ms74w2TUPc8f3Vj7Lstg8qVocgChUdVawSbHMzLJgs?=
 =?iso-8859-1?Q?W54i2fJGcmAaZfeXkUr3b3GS7eVeG/r6OYeOTSW7WJBpwY/JMkyYnxmxkt?=
 =?iso-8859-1?Q?+QGucEYdl/i2DUkdkJTh2zvUNK1Pdi/MdeDQYy/qguZw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR03MB10456.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(42112799006)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?o1Dqn+mE7F1rOcMMQAiBMhIx81mikWfRNT56ZH4g3M5T1yXLNb8/hE70XW?=
 =?iso-8859-1?Q?7DEvkMnnTgBqsJZ6MREs2ES30hrdDBmz3im6vsSY4ogMNiFtbC/2HdqOLs?=
 =?iso-8859-1?Q?OXD00z5FFJ2Wq78GVT2UhO0S6FRhJLq0kWZKWS8PvWaTEut+v2qKvQHmE9?=
 =?iso-8859-1?Q?gwpM8999e0uKV37QAP6sqKaaBeWlVddFc1XsSoKbY4tH6Fgc1dvBbPx8sH?=
 =?iso-8859-1?Q?lJ3h7ZaQFGjBrgqMTqs+jDB/Wq194STfHNMyts47UbGW69K0ise4EhNZVL?=
 =?iso-8859-1?Q?/Wmja/VSnCE9lOKZGoQVO5kE6vv6IuI0diIIZWpcTRaGkLqYMGbuImopYN?=
 =?iso-8859-1?Q?MSDfIBfij8MOW/X28AIZRuS5i9s528ex90tyquCOa+mynIFeb7Nf2SFy2P?=
 =?iso-8859-1?Q?953B1Zcvq0CHv6U3wEgT4B6jmSNrQ5J3KBDVoZtAS/+/AQNExvpdQIG1i8?=
 =?iso-8859-1?Q?ABLMkzo9b5wC8pv8GoT/dAYuVqB811bHWD00p00Kbq19ZWQZCi88UdRI+E?=
 =?iso-8859-1?Q?N/PHLQuU4l4wH6FVkkLplEB9awM6BWkavvjYkMv0KY4XtrKy0aoZN5x2nS?=
 =?iso-8859-1?Q?j8cDUitv5YWNXxNxbn3lQG8KzFkPM5q4VfjCTxgalYpjxe8UJZ1qOS8+uB?=
 =?iso-8859-1?Q?XWMXxjzfok1bbnpkHuvXlqbT20LjclkJyuIaVjIlFJffDk626c+t/bhKEe?=
 =?iso-8859-1?Q?BL1+Z4XRsFZKwi/rsTjllIvC1xKaI217jKoE8v+ilDhhvuajuXGgavDM2p?=
 =?iso-8859-1?Q?XTRZ+LakCOHvqot1BeAXw5OrLVVfwnElDq6RANK65UHixlv//gykm1FnKz?=
 =?iso-8859-1?Q?xGHD7d+4z4DMTLtgglEnQ8VD79aLs4DT9w6sRRUE2a/W+JaLbs4/4+f3HN?=
 =?iso-8859-1?Q?fjcWwm4nFVf7oYeQVPu+y8F2BO52gWA9SsJP8woyE5sIXzLzgRcUfy4xmN?=
 =?iso-8859-1?Q?Izcg2pmjLrYp9epJuWPYkCoMRmcU/w8klyAgv/B0yJrkMEkfrjq2on28Up?=
 =?iso-8859-1?Q?bmAX0VxRGr/X9n3u1UqILoJteNPI8R/dOQMkIYofvIB3dbrEl7/ZlNuI6q?=
 =?iso-8859-1?Q?j9+Oht08Jg4Bg8Ox1ERL+EpC5QwxlRPLv4RlebK+QVQYQisuTxLeYNjUvB?=
 =?iso-8859-1?Q?Sc/MF0oS3YXS9TCfBDYOYvBZ5zRbD59c5e1eFDqNLhTlLncok0wvZPj7dm?=
 =?iso-8859-1?Q?DOKxU954MYplmNxm+U22FnquatFK6ksIeJvTkVe4FyM0lGkkZveJh4dG52?=
 =?iso-8859-1?Q?ctaf/85S2A4jKQXxUa2wkKucaT6mUjzCjwFvLbLCHiDFnLojwJGjldiBGQ?=
 =?iso-8859-1?Q?4HKEwGnYXjeDCpF1H4/7YyXo7+jKTtpzuBrOS7SJzZy6wx05YPtT0OENCB?=
 =?iso-8859-1?Q?dxwW84Ijul2t9s3sVyFsuefgMrVOjueDIH5tPbaK49DwZuqy22dOQCr2aS?=
 =?iso-8859-1?Q?BUmRPJGU7jMI7Tlm7asT6q+CgJEtSQhHhXJUVk3EDT614Z2jTdppJKyIMC?=
 =?iso-8859-1?Q?qM99u6m6/Ow/l/jWuZkh/rwUeYBwOs5/+88PPrHkuXDZbH6lsoeCJsyij6?=
 =?iso-8859-1?Q?7jZd+rhx+LEWEPmrFlvLcd+oEHK+O1Bviv5u94rk44tXYhUEYOnZYJACef?=
 =?iso-8859-1?Q?CyJeFL1qW03A7QmdZIUzRYK5XLTQE20xbz3qtPd+4+HYksMQ5LD0pUcQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fd5048a-a160-4474-5301-08ddd4f409cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2025 14:17:55.7599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZFy+OSmPr/jeAKM2xd+sWZH8RwWTEyE42UQK0luFewEdGBWNMxorAdIl+Pm0KLs0tMX2qfDwak6pcBffHKKcOx2BZpaR0CzVjNWmKyeso2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR03MB8803

Previously this code update only vCPU's in-memory value, which is good,
but not enough, as there will be no context switch after exiting
exception handler, so in-memory value will not get into actual
register.

It worked good enough for VHE guests because KVM code tried fast path,
which of course updated real PAR_EL1.

Signed-off-by: Volodymyr Babchuk <volodymyr_babchuk@epam.com>
---
 arch/arm64/kvm/sys_regs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7b8a0a6f26468..ab2b5e261d312 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3463,6 +3463,9 @@ static bool handle_at_s1e2(struct kvm_vcpu *vcpu, str=
uct sys_reg_params *p,
=20
 	__kvm_at_s1e2(vcpu, op, p->regval);
=20
+	/* No context switch happened, so we need to update PAR_EL1 manually */
+	write_sysreg(vcpu_read_sys_reg(vcpu, PAR_EL1), par_el1);
+
 	return true;
 }
=20
@@ -3473,6 +3476,9 @@ static bool handle_at_s12(struct kvm_vcpu *vcpu, stru=
ct sys_reg_params *p,
=20
 	__kvm_at_s12(vcpu, op, p->regval);
=20
+	/* No context switch happened, so we need to update PAR_EL1 manually */
+	write_sysreg(vcpu_read_sys_reg(vcpu, PAR_EL1), par_el1);
+
 	return true;
 }
=20
--=20
2.50.1
