Return-Path: <SRS0=bv25=S2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A4C0C282E1
	for <kvmarm@archiver.kernel.org>; Wed, 24 Apr 2019 14:30:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 18D4D218FD
	for <kvmarm@archiver.kernel.org>; Wed, 24 Apr 2019 14:30:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="VlhObDle"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 18D4D218FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7F6E4A480;
	Wed, 24 Apr 2019 10:30:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UoBI+lFCU5us; Wed, 24 Apr 2019 10:30:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61AF54A4D4;
	Wed, 24 Apr 2019 10:30:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF72C4A480
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 10:30:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0rzAJNvRRx5a for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Apr 2019 10:30:46 -0400 (EDT)
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr10079.outbound.protection.outlook.com [40.107.1.79])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D29B4A47A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 10:30:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector1-arm-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pqG7LhcYQzNK7irGml2veoTrgl9dQWExDfo6YWNWDu0=;
 b=VlhObDlerhY4vA6fImOVqcUVh/DIQNvdKwy6h91w2Opbkn+Wd5siFz9ozUhyAEgxS0XGduB3xUt3HbH0UbFh06glkcgWRNjbcDdNMFWqd6yDDZBgaE0oBw7jRSeX1nRR/w+OY9CNX2TDLViVrrBR0sIVHLfpJLEOb5kV3RGdMlc=
Received: from VE1PR08MB4847.eurprd08.prod.outlook.com (10.255.113.87) by
 VE1PR08MB5085.eurprd08.prod.outlook.com (20.179.29.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.14; Wed, 24 Apr 2019 14:30:43 +0000
Received: from VE1PR08MB4847.eurprd08.prod.outlook.com
 ([fe80::3582:3f31:4569:21a3]) by VE1PR08MB4847.eurprd08.prod.outlook.com
 ([fe80::3582:3f31:4569:21a3%8]) with mapi id 15.20.1813.017; Wed, 24 Apr 2019
 14:30:43 +0000
From: Dave P Martin <Dave.Martin@arm.com>
To: Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH v10 2/5] KVM: arm/arm64: context-switch ptrauth registers
Thread-Topic: [PATCH v10 2/5] KVM: arm/arm64: context-switch ptrauth registers
Thread-Index: AQHU+Y8LLN0qY1301kuXxM6+yNZcpqZLY9CA///9TgCAAABZgA==
Date: Wed, 24 Apr 2019 14:30:43 +0000
Message-ID: <20190424143041.GF17864@e103592.cambridge.arm.com>
References: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
 <1555994558-26349-3-git-send-email-amit.kachhap@arm.com>
 <20190424133903.GU3567@e103592.cambridge.arm.com>
 <4e475e1f-80f2-372a-2c16-a03ac947525a@arm.com>
In-Reply-To: <4e475e1f-80f2-372a-2c16-a03ac947525a@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.5.23 (2014-03-12)
x-originating-ip: [217.140.106.49]
x-clientproxiedby: LO2P265CA0313.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::13) To VE1PR08MB4847.eurprd08.prod.outlook.com
 (2603:10a6:802:a6::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Dave.Martin@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 916b8688-a312-4c17-e514-08d6c8c16ee0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0; PCL:0;
 RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);
 SRVR:VE1PR08MB5085; 
x-ms-traffictypediagnostic: VE1PR08MB5085:
x-microsoft-antispam-prvs: <VE1PR08MB5085D8AF1C7344C2A6378B6CFE3C0@VE1PR08MB5085.eurprd08.prod.outlook.com>
x-forefront-prvs: 00179089FD
x-forefront-antispam-report: SFV:NSPM;
 SFS:(10009020)(376002)(366004)(39860400002)(396003)(346002)(136003)(40434004)(199004)(189003)(7736002)(6862004)(25786009)(14444005)(66556008)(6246003)(58126008)(66476007)(71200400001)(53936002)(99286004)(5024004)(76176011)(316002)(256004)(6436002)(71190400001)(5660300002)(6486002)(73956011)(54906003)(66446008)(6636002)(64756008)(52116002)(229853002)(305945005)(1076003)(4326008)(446003)(476003)(26005)(486006)(386003)(53546011)(81166006)(8676002)(102836004)(2906002)(33656002)(3846002)(8936002)(11346002)(97736004)(68736007)(6506007)(81156014)(66946007)(14454004)(186003)(6116002)(478600001)(66066001)(93886005)(72206003)(6512007)(86362001);
 DIR:OUT; SFP:1101; SCL:1; SRVR:VE1PR08MB5085;
 H:VE1PR08MB4847.eurprd08.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; A:1; MX:1; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: y9L11XgMbGaXkhJj5h78+kuubTExF8JPftRRKhMrmyYogpb2Bh9fvQUsVBtKM4BlC9WuJ3v/AmLlgn64jR9Ea4v3zScs+BW+Qcciw7YQGzXWT/WRokFbtfwm6PC26CdHT0uZHVbBYRuJ5VSvScrr+nPiRflwk+Fq0X3JyPxMLNJTYZ7mE9pr7T9jENROTnZeHa7xnqrOK9qnzzAGvRzbl9PaIyLoR0+LhxFcqkjcfIP3evH3GXx383pzmd/oltgkl//4AIzCCuPaL7IfF0HdNUF3VWf6AEIflkE+FZ+VhvlVuCbGldxewqCC+y+pVIlaFpz2TTtxZPHC2UHc75s7usQlLwHU5Qt7Wi1LUUXbzQ99vdQmaqek3sCQhGOHhhybc85PFqXlq+3CaVU4DxbQSOZFkEom5ltVwSY6Etl6yVs=
Content-ID: <D2A58B168B45CC428E0A9CEAA7BD1BB8@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 916b8688-a312-4c17-e514-08d6c8c16ee0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2019 14:30:43.6341 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5085
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
 Will Deacon <Will.Deacon@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Kristina Martsenko <Kristina.Martsenko@arm.com>,
 Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
 Amit Kachhap <Amit.Kachhap@arm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190424143043.uQlY7_HJfw0qp0zrDunlnT4E8pene8o6e1U8n26dCtM@z>

On Wed, Apr 24, 2019 at 03:29:26PM +0100, Marc Zyngier wrote:
> On 24/04/2019 14:39, Dave Martin wrote:
> > On Tue, Apr 23, 2019 at 10:12:35AM +0530, Amit Daniel Kachhap wrote:
> >> From: Mark Rutland <mark.rutland@arm.com>
> >>
> >> When pointer authentication is supported, a guest may wish to use it.
> >> This patch adds the necessary KVM infrastructure for this to work, with
> >> a semi-lazy context switch of the pointer auth state.
> >>
> >> Pointer authentication feature is only enabled when VHE is built
> >> in the kernel and present in the CPU implementation so only VHE code
> >> paths are modified.
> >>
> >> When we schedule a vcpu, we disable guest usage of pointer
> >> authentication instructions and accesses to the keys. While these are
> >> disabled, we avoid context-switching the keys. When we trap the guest
> >> trying to use pointer authentication functionality, we change to eagerly
> >> context-switching the keys, and enable the feature. The next time the
> >> vcpu is scheduled out/in, we start again. However the host key save is
> >> optimized and implemented inside ptrauth instruction/register access
> >> trap.
> >>
> >> Pointer authentication consists of address authentication and generic
> >> authentication, and CPUs in a system might have varied support for
> >> either. Where support for either feature is not uniform, it is hidden
> >> from guests via ID register emulation, as a result of the cpufeature
> >> framework in the host.
> >>
> >> Unfortunately, address authentication and generic authentication cannot
> >> be trapped separately, as the architecture provides a single EL2 trap
> >> covering both. If we wish to expose one without the other, we cannot
> >> prevent a (badly-written) guest from intermittently using a feature
> >> which is not uniformly supported (when scheduled on a physical CPU which
> >> supports the relevant feature). Hence, this patch expects both type of
> >> authentication to be present in a cpu.
> >>
> >> This switch of key is done from guest enter/exit assembly as preparation
> >> for the upcoming in-kernel pointer authentication support. Hence, these
> >> key switching routines are not implemented in C code as they may cause
> >> pointer authentication key signing error in some situations.
> >>
> >> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> >> [Only VHE, key switch in full assembly, vcpu_has_ptrauth checks
> >> , save host key in ptrauth exception trap]
> >> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> >> Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> >> Cc: Marc Zyngier <marc.zyngier@arm.com>
> >> Cc: Christoffer Dall <christoffer.dall@arm.com>
> >> Cc: kvmarm@lists.cs.columbia.edu
> >> ---
> >> Changes since v9:
> >>
> >> * Removed hardcoding of enum values[Mark Zyngier].
> >> * Changed kvm_ptrauth_asm.h to kvm_ptrauth.h[Mark Zyngier].
> >> * Removed macro __ptrauth_save_state and applied inline [Marc Zyngier].
> >> * Moved kvm_arm_vcpu_ptrauth_setup_lazy, kvm_arm_vcpu_ptrauth_enable and
> >>   kvm_arm_vcpu_ptrauth_disable from *.c to kvm_emulate.h file [Marc Zyngier].
> >> * Added/Modified comments at few places [Marc Zyngier].

[...]

> >  if (id == SYS_ID_AA64PFR0_EL1 && !vcpu_has_sve(vcpu)) {
> >  val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> > -} else if (id == SYS_ID_AA64ISAR1_EL1) {
> > -const u64 ptrauth_mask = (0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> > - (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> > - (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> > - (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
> > -if (!vcpu_has_ptrauth(vcpu)) {
> > -if (val & ptrauth_mask)
> > -kvm_debug("ptrauth unsupported for guests, suppressing\n");
> > -val &= ~ptrauth_mask;
> > -}
> > +} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
> > +val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> > + (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> > + (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> > + (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
> >  }
> >
> >  return val;
> >
>
> Since the series isn't in -next yet, I've squashed the above with the
> other nits I had in -queue.

Okey doke.

Thanks
---Dave
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
