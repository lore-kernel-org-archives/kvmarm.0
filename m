Return-Path: <SRS0=95sP=VA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA22C0650E
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 13:59:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 78867218A3
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 13:59:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="87C8volS";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="V3sj3d9M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78867218A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E80334A511;
	Wed,  3 Jul 2019 09:59:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W1Qhv3xnyAtY; Wed,  3 Jul 2019 09:59:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A82674A4FC;
	Wed,  3 Jul 2019 09:59:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECA1E4A4FA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jul 2019 09:59:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bUWrYB9RWnUK for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Jul 2019 09:59:36 -0400 (EDT)
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr10081.outbound.protection.outlook.com [40.107.1.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 303974A4CD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jul 2019 09:59:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNjqZ+aenZhYUq/YghJPylXcAvK1uOEnMqDjRInX0F4=;
 b=87C8volSZekeGaTts18u1345Rh6w+PtdvPMsEZ8ylId0DCn6WgxQjtvUZapyigS5koPGnQGc8Dw9LnYEg08KGRwZkupGHyWJ4actQqDtyV5YaoKjC+27oJXn0dv4x8HsaPfspDsjBEAJpgog5OuVd3Gup4uBEklrBu2QZDIWFGs=
Received: from VI1PR0802CA0025.eurprd08.prod.outlook.com
 (2603:10a6:800:a9::11) by VI1PR08MB3966.eurprd08.prod.outlook.com
 (2603:10a6:803:df::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2032.17; Wed, 3 Jul
 2019 13:59:32 +0000
Received: from AM5EUR03FT031.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e08::209) by VI1PR0802CA0025.outlook.office365.com
 (2603:10a6:800:a9::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2032.18 via Frontend
 Transport; Wed, 3 Jul 2019 13:59:32 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=temperror action=none header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT031.mail.protection.outlook.com (10.152.16.111) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2032.15 via Frontend Transport; Wed, 3 Jul 2019 13:59:31 +0000
Received: ("Tessian outbound a1cd17a9f69b:v23");
 Wed, 03 Jul 2019 13:59:31 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 2424c75720940826
X-CR-MTA-TID: 64aa7808
Received: from 0fb0bc6fd120.1 (ip-172-16-0-2.eu-west-1.compute.internal
 [104.47.10.55]) by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 353DFCD1-7691-4501-8F9A-DDF356E57FD9.1; 
 Wed, 03 Jul 2019 13:59:25 +0000
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2055.outbound.protection.outlook.com [104.47.10.55])
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 0fb0bc6fd120.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
 Wed, 03 Jul 2019 13:59:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+c2srtvv4DksdOXSnWGlVY0thhjRxq2E2vL/aPmkhXk=;
 b=V3sj3d9MbrVe33Y/tCxbLeYbyca8Dyze6SHXrxeEfgoduW/igwTSDdl50yZU3lZbqJ8VNK1iBQSzRerIwRa1vY7s4dJbUhjZogS62LfjjWDM/PeO8wBm2eqp4S+s82h0cnMt/2BdjfDuvzZDK7Cgxym/AQaYoW7Y5BxgOPUhqs4=
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (10.255.97.141) by
 AM6PR08MB4951.eurprd08.prod.outlook.com (10.255.120.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 13:59:24 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::c178:d92c:7890:dde4]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::c178:d92c:7890:dde4%4]) with mapi id 15.20.2052.010; Wed, 3 Jul 2019
 13:59:24 +0000
From: Alexandru Elisei <Alexandru.Elisei@arm.com>
To: Marc Zyngier <Marc.Zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu"
 <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 32/59] KVM: arm64: nv: Hide RAS from nested guests
Thread-Topic: [PATCH 32/59] KVM: arm64: nv: Hide RAS from nested guests
Thread-Index: AQHVKBVSo+n491sHA0G5dXeF83Z7Iqa4/t6A
Date: Wed, 3 Jul 2019 13:59:24 +0000
Message-ID: <94798498-08fb-785e-e03e-3d732952a5a1@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-33-marc.zyngier@arm.com>
In-Reply-To: <20190621093843.220980-33-marc.zyngier@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P123CA0012.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::24) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:c7::13)
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Alexandru.Elisei@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.140.106.54]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 66abf6a0-cecb-4db4-8f4f-08d6ffbeac04
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0; PCL:0;
 RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);
 SRVR:AM6PR08MB4951; 
X-MS-TrafficTypeDiagnostic: AM6PR08MB4951:|VI1PR08MB3966:
X-Microsoft-Antispam-PRVS: <VI1PR08MB3966425349EAF5F250EF447786FB0@VI1PR08MB3966.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:7219;OLM:7219;
x-forefront-prvs: 00872B689F
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;
 SFS:(10009020)(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(199004)(189003)(6512007)(2501003)(52116002)(66556008)(386003)(6506007)(53546011)(102836004)(66446008)(476003)(6436002)(11346002)(2171002)(6246003)(2906002)(229853002)(66946007)(73956011)(66476007)(64756008)(76176011)(110136005)(53936002)(26005)(446003)(31696002)(186003)(99286004)(316002)(2201001)(2616005)(54906003)(86362001)(7736002)(71200400001)(6486002)(44832011)(81156014)(8936002)(81166006)(71190400001)(31686004)(486006)(36756003)(5660300002)(4326008)(66066001)(25786009)(14454004)(68736007)(256004)(14444005)(8676002)(72206003)(478600001)(305945005)(3846002)(6116002);
 DIR:OUT; SFP:1101; SCL:1; SRVR:AM6PR08MB4951;
 H:AM6PR08MB4756.eurprd08.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; A:1; MX:1; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: SUHxHA5HC+RnpUGc5hfB6FbNXo1TYRQcm9Z9xPi/nULprM7qyrnDcGJkARKJzxZ1bm32L9OYSB8Np9DdiPRM2CTDBElHOs6Tvip3DQL9tZRo4gfsmLtiCDIlasuoqWIyX+3Dw9e0FO3D9Xe0fhnrYERZ4Y0/sMzm0I42RI7WjMZ8Ijkw1lCeIzdUZqgI8WubP6XlM2mUwy6DuYRlPbJx4omUbpWcJm88gUG2R5OTaeI4ouRKAsfGV6I6BDfAlgiwO16oJRRQngGD0OYei/WW4qbYCrYCftRL4auLs5KWEJ25DgfoVmNoqad2zP7+wFr5LS6rogYAmG1CQnWA6y7DQ0/FEghssiaUupgw111CSt1k7Ts8rCtHKYco/430SNy1XU6QpHqov1QAQS3hNBS8AijnVwUtWpyogEN7IeFNfvI=
Content-ID: <CE030ECC4F20204AA40DBAA9D8716FA6@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4951
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Alexandru.Elisei@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT031.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; IPV:CAL; SCL:-1; CTRY:IE;
 EFV:NLI; SFV:NSPM;
 SFS:(10009020)(4636009)(376002)(136003)(396003)(39860400002)(346002)(2980300002)(199004)(189003)(40434004)(2486003)(2201001)(23676004)(436003)(7736002)(2616005)(72206003)(31696002)(11346002)(99286004)(446003)(63370400001)(63350400001)(86362001)(50466002)(478600001)(2171002)(76130400001)(36906005)(6486002)(486006)(14444005)(305945005)(126002)(5024004)(476003)(110136005)(14454004)(316002)(26826003)(5660300002)(54906003)(186003)(70206006)(336012)(386003)(70586007)(81166006)(26005)(6246003)(2501003)(6116002)(53546011)(3846002)(22756006)(66066001)(6506007)(31686004)(47776003)(76176011)(356004)(2906002)(6512007)(36756003)(8676002)(8936002)(81156014)(229853002)(25786009)(4326008)(102836004);
 DIR:OUT; SFP:1101; SCL:1; SRVR:VI1PR08MB3966;
 H:64aa7808-outbound-1.mta.getcheckrecipient.com; FPR:; SPF:TempError; LANG:en;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; A:1; MX:1; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: 972a2f14-1bae-4c7b-8286-08d6ffbea79f
X-Microsoft-Antispam: BCL:0; PCL:0;
 RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(710020)(711020)(4605104)(1401327)(2017052603328)(7193020);
 SRVR:VI1PR08MB3966; 
X-Forefront-PRVS: 00872B689F
X-Microsoft-Antispam-Message-Info: oK17QVgP1cQDmuyIcvSVfbvU4XQaqbEYGMErE08cWUK5YFsUew96F/zD+W84uHMIMm+vUuAMtwpFgOSDYIjCNf/xD5qh3Wvj5dK23jQf6i+eXGsv3aJB5eejLYv1XIa2l6lk5Gt5oKq39YCPKyVVQW4UkEH8RCVAJbgOJf8o1uH6VFo3YD48zsFAxNvSNCZaaFmM1FqJkrL1iBslTTRzpUpNZTPGCusLOCG/viNNbAMgDRyV7s37p9L49T6d1EApNnpLoEU3rLPPm7AT7jIka0X/5bvyH/P2Fi0G1NpM37MX/OM9cjTeXecCITMdOj9N+sZRbAvn0gdUqdtJjr9vUILC+YGNkUKkA7bNpHZr90HIIJjwZnic+g1vaLj6JxPqdsOXI2FphO/YddiwLi97wEZ1sjt+3kz1IF0Zlrj1ltQ=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2019 13:59:31.3061 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66abf6a0-cecb-4db4-8f4f-08d6ffbeac04
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3966
Cc: Andre Przywara <Andre.Przywara@arm.com>,
 Dave P Martin <Dave.Martin@arm.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


On 6/21/19 10:38 AM, Marc Zyngier wrote:
> We don't want to expose complicated features to guests until we have
> a good grasp on the basic CPU emulation. So let's pretend that RAS,
> just like SVE, doesn't exist in a nested guest.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 32 +++++++++++++++++++++++++++++---
>  1 file changed, 29 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 34f1b79f7856..ec34b81da936 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -577,6 +577,14 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
>               return read_zero(vcpu, p);
>  }
>
> +static bool trap_undef(struct kvm_vcpu *vcpu,
> +                    struct sys_reg_params *p,
> +                    const struct sys_reg_desc *r)
> +{
> +     kvm_inject_undefined(vcpu);
> +     return false;
> +}
> +
>  /*
>   * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
>   * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
> @@ -1601,13 +1609,15 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  }
>
>  /* sys_reg_desc initialiser for known cpufeature ID registers */
> -#define ID_SANITISED(name) {                 \
> +#define ID_SANITISED_FN(name, fn) {          \
>       SYS_DESC(SYS_##name),                   \
> -     .access = access_id_reg,                \
> +     .access = fn,                           \
>       .get_user = get_id_reg,                 \
>       .set_user = set_id_reg,                 \
>  }
>
> +#define ID_SANITISED(name)   ID_SANITISED_FN(name, access_id_reg)
> +
>  /*
>   * sys_reg_desc initialiser for architecturally unallocated cpufeature ID
>   * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
> @@ -1700,6 +1710,21 @@ static bool access_spsr_el2(struct kvm_vcpu *vcpu,
>       return true;
>  }
>
> +static bool access_id_aa64pfr0_el1(struct kvm_vcpu *v,
> +                                struct sys_reg_params *p,
> +                                const struct sys_reg_desc *r)
> +{
> +     u64 val;
> +
> +     if (!nested_virt_in_use(v) || p->is_write)
> +             return access_id_reg(v, p, r);

So SVE is masked in the nested case in access_id_reg (which calls read_id_reg,
modified in patch 25 of the series). Looks to me that the above condition means
that when nested virtualization is in use, on reads we don't go through
access_id_reg and we could end up with SVE support advertised to the guest. How
about we hide SVE from guests here, just like we do with RAS?

> +
> +     val = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> +     p->regval = val & ~(0xf << ID_AA64PFR0_RAS_SHIFT);
> +
> +     return true;
> +}
> +
>  /*
>   * Architected system registers.
>   * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
> @@ -1791,7 +1816,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>
>       /* AArch64 ID registers */
>       /* CRm=4 */
> -     ID_SANITISED(ID_AA64PFR0_EL1),
> +     ID_SANITISED_FN(ID_AA64PFR0_EL1, access_id_aa64pfr0_el1),
>       ID_SANITISED(ID_AA64PFR1_EL1),
>       ID_UNALLOCATED(4,2),
>       ID_UNALLOCATED(4,3),
> @@ -2032,6 +2057,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>       { SYS_DESC(SYS_VBAR_EL2), access_rw, reset_val, VBAR_EL2, 0 },
>       { SYS_DESC(SYS_RVBAR_EL2), access_rw, reset_val, RVBAR_EL2, 0 },
>       { SYS_DESC(SYS_RMR_EL2), access_rw, reset_val, RMR_EL2, 0 },
> +     { SYS_DESC(SYS_VDISR_EL2), trap_undef },
>
>       { SYS_DESC(SYS_CONTEXTIDR_EL2), access_rw, reset_val, CONTEXTIDR_EL2, 0 },
>       { SYS_DESC(SYS_TPIDR_EL2), access_rw, reset_val, TPIDR_EL2, 0 },
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
