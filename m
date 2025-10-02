Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013021.outbound.protection.outlook.com [52.101.83.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A48CE555
	for <kvmarm@lists.linux.dev>; Thu,  2 Oct 2025 15:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759417700; cv=fail; b=DwUHJ8jWK7O24jm+/vOVYNAK7OGTYXTiSww1zqh/Y/ZSR3xgjmuF7Gz3Ahu++FgR7FoxBp47CrePCGBxAJf0zsUnxggvomW32P5iXLidTCuic18we1mAnwCQRzticaDjYvSLETtsYzR3vpIjwJc+eriVNWBcNa/ydxnB5gK47Ck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759417700; c=relaxed/simple;
	bh=BuHNPlPl/sOeLR9bYoIjGh0nxiYk1ktfIet2zhQiKaU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZteWJG0dcAPtFY/UcKpQZUmE8FNQTHVM8LXkdhsidtXjebBFLJ1sJF3GDgykj1E/QwnKmo/F0EVxjUQwfnZI4IlS37a7MpbssjbgqZWPJZYW55msatZCqAuhPFOaVscgLwyXo7sAHNLEfpFD9e2fE3ZjMBHFwrmgAE0EQ3dCLsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com; spf=pass smtp.mailfrom=epam.com; dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b=fYSMzjB4; arc=fail smtp.client-ip=52.101.83.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=epam.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b="fYSMzjB4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G+Dv+a0x7Rr/CsQUJIvBTGP+qh4x+TQE9khgsi7//KfFHEYUOkB5YmanOQvHjQlF0hyFWeS0rmxEBt1bMwSZUyQ1PkuoPOxFBbsNY+jzrQ9ATNa8f22Ie6Kl2/BhVgahvl6pHCp56K0/JPPK3LTcyA5ngnAJ91iKpAcF/n8E/LGlrG2jU1meSgDz5CS0d7Ul/jJWy1Dhlubsq8hvCNIvbfKqa13KNgHwmMRWTJacJxU9il/sgyfmzaYXnkGtvnz2kHKS4Eexe5zkoyzZkzgSBBNuNJD3HLRMOBJhDIWcXTYOfnyjtByJ1+olsbKcbAoVFted5thPKsM8rSISu8dCWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=74h9RmrEn74gjAVtTj3IHJFCSkrx64MUoSN1wTTiAeA=;
 b=fKwZkJilvA2cw7GdRtWyENS1r2yd+OmewLleUIK1b5091Q+KlHAjyhp1JK85HZ4PUp+KR01we356Ob01tX6iewhXuoilLOiaYimQoHEg0Dmtzp96t/yL33nX3N9psQNWz2Ad1cCQFdnXjSWiAQMvf1MVqORgN7jSP8oXuKSrrxcE7DAJGeesf25BzGLw3pYBIoLtulQKV8ZZkbTurwPj2jwb2P4Kn01mhlF2Nw71uNm+i6xkFRlvixvoiEpP1negghoFKqHdOTaBQ05XQ/+EMGcn74r6ZHhxAgituoAGzoP/AXaj2EcITR7x4R5ub0C4dXsrqN0Bv89tKhGWQfbc9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74h9RmrEn74gjAVtTj3IHJFCSkrx64MUoSN1wTTiAeA=;
 b=fYSMzjB4r2xOH5cOnqgFDy21afMMmoSRxwr8Eavs8w4q34EWTpjN4fGYJAQJ8K8KdzUeE8qlFRZt6AO17eGjIpf2I43/7adkv6axoGandQeEJU2/0/bRR/fL/IE0vk5CPXclWBW3wXNIf9bb6X9D3xIUDnyAPT9ULVIcZKEZ23D82XquJuQ2a6IaixG0jytWKBx8C7bOhjJEBtQO+W0G3++e2xHkzi3spi1Jvc9qff3aR/Vp8mrsch0jkraJoY8f7p7MQw3tGB91woQh0Vne33C03ZB2HBN819sZbeDKjAhM0ShUsTs08WSXVcq/sKFbGh7XHsF1AJzJHddJnMJ8cA==
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 (2603:10a6:150:16a::21) by PA6PR03MB10405.eurprd03.prod.outlook.com
 (2603:10a6:102:3d4::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Thu, 2 Oct
 2025 15:08:10 +0000
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e]) by GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e%7]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 15:08:10 +0000
From: Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
To: Marc Zyngier <maz@kernel.org>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Dmytro Terletskyi
	<Dmytro_Terletskyi@epam.com>, kvmarm <kvmarm@lists.linux.dev>
Subject: Re: KVM: Nested VGIC emulation leads to infinite IRQ exceptions
Thread-Topic: KVM: Nested VGIC emulation leads to infinite IRQ exceptions
Thread-Index: AQHcMk7Yj++4l3leA0uVFgouU6YiFg==
Date: Thu, 2 Oct 2025 15:08:09 +0000
Message-ID: <87cy75nxyf.fsf@epam.com>
References: <87bjmrprvq.fsf@epam.com> <86seg3ytk2.wl-maz@kernel.org>
	<873481pjuz.fsf@epam.com> <86bjmpz8cc.wl-maz@kernel.org>
In-Reply-To: <86bjmpz8cc.wl-maz@kernel.org> (Marc Zyngier's message of "Thu,
	02 Oct 2025 15:28:19 +0100")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=epam.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GV1PR03MB10456:EE_|PA6PR03MB10405:EE_
x-ms-office365-filtering-correlation-id: 1886289e-599c-4888-5f68-08de01c57fff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|42112799006|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?bAhIUspfBDkG6QVBiIY/HugR4S11jg22uxBnphwCHcwx+mHM9kmkvw32zx?=
 =?iso-8859-1?Q?Hpl319ou6pcWIFzDSHR5h58UIfQgWc9yzBvF7A+lHgUNBpt3VK4DnjobMj?=
 =?iso-8859-1?Q?DFY595K3wV5sFT+MJpQpO3rXMtdXSqnKUt6Yo+AwacMm8coBwzvo4umc/q?=
 =?iso-8859-1?Q?zRU4Ac9k+86hwiRzXQ9fmNgICozaH1zeVpYueAx0OlaM3to/b9kwbrAq8h?=
 =?iso-8859-1?Q?sMz1ljNiCYRwGpnTu1EAmaUsW9FnGraxZTCtdG09GWVnzn6VKdG5CvSqsa?=
 =?iso-8859-1?Q?xt7RIparug0Jp/oHrDLuSISUjILqSoRGkWguRB/JpiTs3Y3sNkr92A4WHB?=
 =?iso-8859-1?Q?prxnDleRsa7R0XOE8y2qducdamK2mR+7AX4i1LxqvkveBhblAYEFaEpxgh?=
 =?iso-8859-1?Q?k8JlgEsml3nkMbZEH3U46dUjVlzxWj4fdjUg/3vMp2gZeJ8YDnLAeN8Qip?=
 =?iso-8859-1?Q?tGKvR0fX4vruv36H2XBHHPGfL0Q9GMEaDKyK0xJD8i3y3RhhDO4puOLa5K?=
 =?iso-8859-1?Q?hCHczAwoyInlQe/QqVIbs2SDiwD2v2ZJ/9YxOuvnZgqQURyVaeMkbmGq1I?=
 =?iso-8859-1?Q?46REHn8xiryyCf7KLUybaNyp68Rl/mcX2/EjVSdAUNz+tbZKqU1ghxxNcG?=
 =?iso-8859-1?Q?1RFZeVXQTJSR2B/o7756UiZHhjdCvqp4u/0ggHVom6q35lXy3wbOup8bBv?=
 =?iso-8859-1?Q?hP4Bx8D2rVqKgm8trs+lGVF9bnfQDydn7Gt3Y9ju1IAaxCPBYedUntYOdw?=
 =?iso-8859-1?Q?VDeHuIaauXiIl2lEbKxLPLYsvjlHF5YjWp6T3J5INo7sh4ro5a/YRqStNH?=
 =?iso-8859-1?Q?iRpoDcvdyhT027sYA2D93d0gmRI+/Z9ntc4pXpRu4Qh0J6ptGTlrzsZvZ3?=
 =?iso-8859-1?Q?4XCYjDvAx7GQdy7Pv/LrBw34a6T/HHGrZpsXUY9MuMstHlsucHyd6OMjY6?=
 =?iso-8859-1?Q?sBQecKY1O7D5oirqDs0k/r4sX5eiQl1bQiANUtc+pCYnt7RCMB0/O5xrMn?=
 =?iso-8859-1?Q?2Upayf9QEmZLJLxheRCSTiKYkRqCMDj4WPA0SD2gIK6fDA9wAk4VkH+V8u?=
 =?iso-8859-1?Q?6dWoP5dm5d6rXhzh0GDZrIZbG7k9HT6XVVmx92b9wSclJ/b8GONBJgQrCo?=
 =?iso-8859-1?Q?eXQYgxI6hljoHgy1ChYJ0bTm6VAESwc3qvJuATVIzSJAM9h57lDejYmtX6?=
 =?iso-8859-1?Q?WKYWnPidHPQ4xnxB9Miz/7ztEcOedhHNOSAblCaRufSneYvIklA3XF3GwQ?=
 =?iso-8859-1?Q?1SOHQ3ROc7iRVyJi9D3TXHVW+XFeYzRB/XtyEgxVr0SCKASCKi2tvtlQo1?=
 =?iso-8859-1?Q?/KSn+OeOgTGGe1K1m+YF/8tKViFnZgOH9qEa3p6Y6VGGCAGHiodeJp/22Y?=
 =?iso-8859-1?Q?kTSKZFQqtDFrpiKU5kUocdNp1v/CJ+XNZcK+vmFXJofRVJfxTMUPJ8vlGG?=
 =?iso-8859-1?Q?x8JHp43aco25blWJILsKMrEL5bNiezaIQb7Q+JZUTatbH73n4wcuuGMCqG?=
 =?iso-8859-1?Q?T5tJGKjWf8HLgg/CX1bWu6rS55HZYg8MKY1tuzWUMWWZ1ki546jj+M6XFe?=
 =?iso-8859-1?Q?edmOXuJfr7xbFx3kBjez0r7fs69c?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR03MB10456.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(42112799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?XaOt0jpaan8ABuPG45PlwWXRefBlJKQkDnTXkaLK0gzVyNPZ4L/SswM7KD?=
 =?iso-8859-1?Q?nHWZVY0xEzAsOA1uEurnUqq5C2NqFnmN7e8DnHiaZBJ306SXCxasq4rFs9?=
 =?iso-8859-1?Q?v43goXyA2Ef2a2w+a72ZmIfX54JOcKYDoFITevYv0K/8BBp18kRhq8kXnE?=
 =?iso-8859-1?Q?wFOgGqFJOhx4h2DPTc03TMlSs5dmGMPaWzJBbcTHS3X+aPtId19QNsChPQ?=
 =?iso-8859-1?Q?kv5EeM0vJRwTDdUOI0A3rJMEirE8wh+7rUTFjovNb5HYByIYddjl1+zBSk?=
 =?iso-8859-1?Q?FOQv2m2VgNuGX3xrIAaYami+CPgIBaKCicWj4LfoYqg+czvf3kboUVIpJ+?=
 =?iso-8859-1?Q?jIRiSritvNJ7QUrQR1f8GXlB8+GKDyeeB2o6q2TVmsRHJ0JqT6rMdw5Sne?=
 =?iso-8859-1?Q?O+XmvHhBVDFwmd55/3wTv1Xijv6ccc633tNUfbees+2IM/0MtLL3bP1z5r?=
 =?iso-8859-1?Q?n1TtG1qfJs+uRvvWGt+mCks23QmhgyA0+weS76Gq/iqDYMgz6+tDSCGIVk?=
 =?iso-8859-1?Q?8ZC12/R4YrQrH2AoEixAk0ExfmaWQFz3ZSD//dxbvnbzy47E9UV+oif3Sd?=
 =?iso-8859-1?Q?m8BZoFy6DNEG7naxDFhHueQ6gXirKpQ0twFgDEdXcDhAB6I2WX291YNypy?=
 =?iso-8859-1?Q?jvTVSXxffZ+FejEvP3LSa6nEy6K90r1w8ybepEy5UfHtui0mHDkAsZL5j7?=
 =?iso-8859-1?Q?MC+BplZN3yb86KnBkBG8B5euhOkvemyjRSKoGdHdGEK3LBFkpdltghK5Yg?=
 =?iso-8859-1?Q?oqWl9udqRrHTbbIVxDeVLNoWBSwn1IbTSXM2HL9czP2WlGivE6+TZTbx+1?=
 =?iso-8859-1?Q?zdy8yDbm1YGzFIXOFjhYsFoGn3/P7io0sEGIzCxmDVhgs9XSlvvrMscbAj?=
 =?iso-8859-1?Q?hdh7ePUllx5tLJRrrIkLV9b3xC/5xhO+iKNQalLZHXM9dFQXyCnYiBfQ2n?=
 =?iso-8859-1?Q?QA6b0/WIuA1A+vKCvXh9KB+YnEmz7Z89CxVy3S1bQVDtWIKHOv05MJ8qQ7?=
 =?iso-8859-1?Q?Pq5Gp/BQDNqEIHfhc9X3XsWM54GgHM0752C+gQLd99x2nkw68zW605YaMg?=
 =?iso-8859-1?Q?pKX1s1H49TnuQebDX695dcDfWeF54wAokm8YhmaPPHmo1ZsMhLEd9GXxCc?=
 =?iso-8859-1?Q?NwZXODDSqnE8drc908AILS9Z5+IwWNu/QR5KxUb2K8rlRS8lXiGokOWN7j?=
 =?iso-8859-1?Q?vCjUln7j+qipwf0F/x73uAYN0gFBjNxV4QQG7h4Y54CRoWMhodRzK2hfY1?=
 =?iso-8859-1?Q?SIhimrawLzc0uPmUPWL4SEyOu3F9dQypxAx+5rkrvKJFBgIoPTM8lNMFqy?=
 =?iso-8859-1?Q?YJP8tI8kB/J64DSt5b3XzsiJGOCXx8RIQCUHD32qhPVjORd+SVYPqsvhB3?=
 =?iso-8859-1?Q?pux9O3s30QFJl0Nsuw8ugUtghGiX5hxEQsPY5R6rirDaUK0KEk6dWdcDtc?=
 =?iso-8859-1?Q?5b9JFpZV1ESJiyzVEjCnUPcw0xgTr/EGj2OJnXFdkUlsi2uWjoJmfJbk1v?=
 =?iso-8859-1?Q?v3C1ZMg4kn75xDsEYjfB3c0qa251pMPtfSIkWkjByFNcOgjbSkTVsgSL8u?=
 =?iso-8859-1?Q?+OlWX035yOuo7vAyD6uuXeeBhq9hMRe4uZtrhK4tGODxHHYL93pQlP1E4B?=
 =?iso-8859-1?Q?CQWgEe9f2DjfLOkfXWr+q5EMfWn2hybmVuRMwksJuRM5+wRJ1ecaLdew?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1886289e-599c-4888-5f68-08de01c57fff
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2025 15:08:10.0430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wg3/XWwLL9sOCT91qnI1rclxvciA3IhRbgYuvaJQ9/MB1LO4TliXO++rXXDwOhoKawaOIbHEogi849PbEYrraBWmnge5lzBc0MlqpP/4NdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR03MB10405


Hi Marc,

Marc Zyngier <maz@kernel.org> writes:

> On Thu, 02 Oct 2025 13:29:42 +0100,
> Volodymyr Babchuk <Volodymyr_Babchuk@epam.com> wrote:

[...]

>>  qemu-system-aar-3378    [085] d....   246.770720: vgic_populate_lr: VCP=
U 1 lr 0 =3D 90a000000000004f
>>  qemu-system-aar-3378    [085] d....   246.770720: vgic_populate_lr: VCP=
U 1 lr 1 =3D 90a000000000004e
>>  qemu-system-aar-3378    [085] d....   246.770720: vgic_populate_lr: VCP=
U 1 lr 2 =3D d0a000000000004a
>>  qemu-system-aar-3378    [085] d....   246.770720: vgic_populate_lr: VCP=
U 1 lr 3 =3D d0a000000000004b
>>=20
>> As all LR entries have ACTIVE bit set, read from IAR1 will produce 1023,
>> of course. Problem is that Xen itself can't deactivate these 4 IRQs as
>> they are directed to DomU, so DomU should active them first. But DomU
>> can't do this as it is never executed.
>
> There is a flaw in your reasoning: if these are DomU (an L2 guest)
> interrupts, why would they impact Xen itself, which is L1? At the
> point of entering Xen, the HW LRs should only contain the virtual
> interrupts that are targeting Xen, and nothing else (the DomU
> interrupts being stored in the shadow LRs).

Agree, they **should**. But looks like they contain all IRQs that are
targeted that particular vCPU. I am still studying KVM's vGIC, so I
can't say why it this happening.

Mind you, that these are QEMUs IRQs, so from Xen's standpoint they are
HW interrupts and of course they are targeting Xen. Xen injects them to
a guest by writing vLR with HW bit enabled.

IMO, KVM should track these re-injected IRQs and remove them from Xen's
LRs. But this begs assumption that Xen (or any other nested hypervisor)
is well-behaved and will not try to deactive a IRQ that it already
injected to an own guest.

>
> I can't see so far how we'd end-up in that situation, given that we do
> a full context switch of the vgic context on each EL1/EL2 transition.
>
> Unless you are actually acknowledging the DomU interrupts in Xen and
> injecting them back into DomU? Which seems very odd as you don't have
> the HW bit set, which I'd expect if that was the case...

Isn't KVM doing the same? I mean, all HW IRQs are targeting hypervisor
and then being routed and re-injected into a guest. AFAIR, only LPIs can
be injected directly to a guest. And, as I said, IRQs in question are
generated by external QEMU, so they are considered HW interrupts by Xen.

>
>> I am not sure what is the correct fix, but I see two options:
>>=20
>> - Prioritize timer IRQs so they always present in LRs
>> - De-prioritize ACTIVE IRQs so they are inserted into LRs last.
>>=20
>> Looks like the second one is better.
>
> That's indeed something missing in KVM (I have long waited until
> someone would do it in my stead, but nobody seem to be bothered) but
> it isn't clear, from what you are describing, that this is the actual
> solution to your problem.
>

Okay, disregard my previous ideas. We can't willy-nilly remove ACTIVE
IRQs from LRs. So, probably we need some sort of heuristic to determine
if L1 hypervisor re-injects IRQ to a L2 guest. I think we can check HW
bit in vLR to determine this. In this case we can differentiate L1- and
L2- targeted IRQs during context switch from KVM to L1/L2 and fill LRs
accordingly.

Of course, as I said, in this case we'll rely on good behavior of L1
hypervisor, because it can try to EOI IRQ that it already injected in a
guest. This is not a huge deal if we are dealing with "virtual" HW
interrupts (generated by QEMU in this case), but it can be tricky with
real HW interrupts generated by a real HW device and injected all the
way to L2.

--=20
WBR, Volodymyr=
