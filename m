Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C91DC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  7 Dec 2021 14:18:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B25A84B14C;
	Tue,  7 Dec 2021 09:18:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XBelBGYamKKt; Tue,  7 Dec 2021 09:18:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EFFA4B0BA;
	Tue,  7 Dec 2021 09:18:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 990124B0A3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 09:18:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JZZp2cfT+yBY for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Dec 2021 09:18:28 -0500 (EST)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-eopbgr60068.outbound.protection.outlook.com [40.107.6.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9ADAC4B092
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 09:18:28 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0yuVmnWT5foV4We9MNI+orPcMfkfwOTXlcKMdShoiUc=;
 b=B6Qe/wSYRd0yHEj/JIGai3E5IM9dmqnQu5tg5708OKYZ3sJnftGgTKxKdoE4wvkhTCneELdu6UlCA3zxsm0KjI7PmNmScgpJuSXVaRZTwZh5hTlYvjEYQLBODgy+g4nayEx6JafrJOEBvSA6fz46+jpPEwohyya9DGaPVRQIg14=
Received: from DB8PR09CA0030.eurprd09.prod.outlook.com (2603:10a6:10:a0::43)
 by DBAPR08MB5830.eurprd08.prod.outlook.com (2603:10a6:10:1a7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Tue, 7 Dec
 2021 14:18:25 +0000
Received: from DB5EUR03FT013.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:a0:cafe::f3) by DB8PR09CA0030.outlook.office365.com
 (2603:10a6:10:a0::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19 via Frontend
 Transport; Tue, 7 Dec 2021 14:18:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT013.mail.protection.outlook.com (10.152.20.105) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.13 via Frontend Transport; Tue, 7 Dec 2021 14:18:25 +0000
Received: ("Tessian outbound c61f076cbd30:v110");
 Tue, 07 Dec 2021 14:18:25 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 71455f1b59d87d45
X-CR-MTA-TID: 64aa7808
Received: from c599a97cee9b.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 1E3ED5D3-8593-444F-9D7B-5401D0B63D9F.1; 
 Tue, 07 Dec 2021 14:17:59 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c599a97cee9b.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Tue, 07 Dec 2021 14:17:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQd47YwbRqnh/qW3AHQVt2W3gCz/AV2RanFexJcBErvbap6ku+D8RYlPn9gxwzNSuT6pCcLcJwpkVRhvJgA0Zc50nP2UEewbzH6fjV5ezG5qkZUh2NgRloLbwSosyIXKDjf0irIG6mMau8AIkdYFyoo680suriA5Jmvr12zszs6LIco2jAsupMBz/GAxfaqeEgrLurzqj6FL00n73+dDR0emxDZgMUl7EMWjlMf6WajLpaDsJhp1P5o0jfyALYhhYDUbUYLeoZ3UyYiqhZZbtsGSqJSRkjeRDqLykr5JZMjBI9r4uWq7Kdvfk/M0CQFdXfyppq5b2dA45lsBbQmA2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0yuVmnWT5foV4We9MNI+orPcMfkfwOTXlcKMdShoiUc=;
 b=gmg/ZQLQu/rXr1+1AtbdnpLUKmSuTM4CCgs9+w4sI6eZ7Ani99GUmQ/l8X3NYGwK2eVHqJkCDd+B2VZbzjggX2MS/ujiXf9wXVZwKUFB/tf70P8xG1kzmDNRfkXbSf3DT6lEWdCz/7LtN1BbrTESaJNBjhRT1ejcgtUM8AGiVRAwbxrDRVD/HRtKs7Bufbd3dywcbkWIsgmSDVNYwha7zw+WwscVFA1nK2D22i2P5yhLJvzEBDBF4OHj9LvNvYDrK9JtFHb1D8PwcUGsBD88bxbOGRfKUCIEa611y1i4sWYx0xR+TCDBlJtpn+iaa9MBzMQrxtoF/wOrg7/RFZ58rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0yuVmnWT5foV4We9MNI+orPcMfkfwOTXlcKMdShoiUc=;
 b=B6Qe/wSYRd0yHEj/JIGai3E5IM9dmqnQu5tg5708OKYZ3sJnftGgTKxKdoE4wvkhTCneELdu6UlCA3zxsm0KjI7PmNmScgpJuSXVaRZTwZh5hTlYvjEYQLBODgy+g4nayEx6JafrJOEBvSA6fz46+jpPEwohyya9DGaPVRQIg14=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB6860.eurprd08.prod.outlook.com (2603:10a6:10:2ae::19)
 by DB6PR0801MB1784.eurprd08.prod.outlook.com (2603:10a6:4:39::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19; Tue, 7 Dec
 2021 14:17:57 +0000
Received: from DB9PR08MB6860.eurprd08.prod.outlook.com
 ([fe80::84a:5981:c268:f896]) by DB9PR08MB6860.eurprd08.prod.outlook.com
 ([fe80::84a:5981:c268:f896%9]) with mapi id 15.20.4755.021; Tue, 7 Dec 2021
 14:17:57 +0000
Date: Tue, 7 Dec 2021 14:17:56 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2 4/4] KVM: arm64: Refuse to run VCPU if the PMU doesn't
 match the physical CPU
Message-ID: <Ya9s2HIuMmWYFIQm@monolith.localdoman>
References: <20211206170223.309789-1-alexandru.elisei@arm.com>
 <20211206170223.309789-5-alexandru.elisei@arm.com>
Content-Disposition: inline
In-Reply-To: <20211206170223.309789-5-alexandru.elisei@arm.com>
X-ClientProxiedBy: LNXP265CA0072.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::36) To DB9PR08MB6860.eurprd08.prod.outlook.com
 (2603:10a6:10:2ae::19)
MIME-Version: 1.0
Received: from monolith.localdoman (82.38.32.78) by
 LNXP265CA0072.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:5d::36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.17 via Frontend Transport; Tue, 7 Dec 2021 14:17:56 +0000
X-MS-Office365-Filtering-Correlation-Id: 1db7f529-a14c-4846-5576-08d9b98c6e8d
X-MS-TrafficTypeDiagnostic: DB6PR0801MB1784:EE_|DB5EUR03FT013:EE_|DBAPR08MB5830:EE_
X-Microsoft-Antispam-PRVS: <DBAPR08MB5830FE860A7EE516C8689E1D866E9@DBAPR08MB5830.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: aATjeU1GAx9PfE1kCN/vzUG8mX15ojxl3GCo9CPqyn5ANRwqNKV4pVMQq/FCPUssCTziiopyO2dQpo3rnlnFXD0LyYFB0vgV/j2smbYfQ6It0k0HlOuExL+QubWCqnFhZ/rL75TaNYpNN2gOL2XPUvRTEP4vUhxyhXC0KfPd6mIRyYxjmI3+CqvjkXvYHAGxsUULiTvBtzJb45A9nVfQefBy7ZL4HgLeYD5ttqWGQfl63BKE5a9pQ7ecugirfNTXukd2nRaRGwb8GEvdlYbDp40gYL6weu85n/pmqOrlDpTB+yhEncDJevXYkrD2rvJxYXQcS+fFMG6hES1O6VMrxRqldhjkjNoooM29J4w37fQTU1uA2RlGo2vFZ+uAsANl2C/s2XbAD5m2tMm4gu2Cm0qv9xNMuFPVzCXp1mg2lKSaQDrOuJUA4FAq0A92e37B8+fppM7vm0J5FqAPf/9/jJFZR9z+vus3KehUUVMpBhLVUPkr8/ZDLNN5G+3ueOe4y1Qn1wCRWSv0dXv52yS+BEGKCMiRpoyxxkhL4dyDRcLiCcTo6msJuOkA53Z+IoSK0vPCz2jpQaKMXxF5gCdGmkqYkBtQRZPLTnkkeGZ0vVvVZlggTwtNElVLuI1ZhyXABC+s1OKqCIa9pOkNZdspq+gGXtZqTCn2r8jORsHtqbDtjV9tBvfRvlOLiv1NTDCvTSodbC9jVAn0wc7L0jehxQ/TAOm/Ez/0Nkn3GUDXkLEfIsGmBhyJe6fmDrfSBUkWGFzAe3L2ON9V2QFE08LDcw==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:DB9PR08MB6860.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(366004)(55016003)(86362001)(83380400001)(4326008)(38100700002)(38350700002)(7696005)(8936002)(2906002)(316002)(44832011)(956004)(966005)(52116002)(8676002)(9686003)(66946007)(5660300002)(66476007)(66556008)(26005)(186003)(508600001)(6506007);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0801MB1784
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT013.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 859e1269-f5af-4e8e-34a1-08d9b98c5db0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0hpWMC2nVBSwoq28k35Yu6hro6kTv0FFsXwGhKxXaVqpUnXD0FhtO0rgkQroTIZPSVNDU2hnlydQvyFUUoW16KhkTl/5gvX9YzVNu2a3h3WbrTXtkZUFjs2EtTgcbzlDVEP9zOxMRBCe+/Ltuds6Z39UF717LPembZpW6Au2PiTEu4kgBBClpezNmzQ47zfHPi+ETCs+upXjj+leZRBQ1917iV3jyLA54IzNsFl1tGch5WnrVUMgBb5BbJWTsOOwe3n+XNAh8MjOAopHkQrJKNDO1vSh8GRZqy5m98Bed+7vZi359tPJTddN61eUNYiHl7OIdxDlV3P4XdiR6fsYPWatge9CWh+JoMa7J4f5dIzgEaCCtgQwwXGNZeFINN7ANqLUl2qQnV80x4p+suSQbLNplUypBgq1M4gejP8T3iXIPfMpKzUFF5bSsvmSLHt9M80sq4JwT0VAox7M8Py8iAEPdYYJ2q0HbXLAPz7Tm0T9gQ9CZJ6pFh3MYWsaKvEntLekZIp10rgB/tBL+0Pa69FXrcmWqW65BasG/5TjakvOo4rAU25IHlt6HQUjJBblELuA3az4wtCY+uEQ0701lCBcJ6R1Fe3bRSJwEfbVLZ7EPiyDLBPrX9LGVL32Ij9nOYI9w1q88t5nLmyOWbbPRHi3/D5Y+lejFISpcW/I30ChahTps26MLkcm9XcSQaZjLHI74uY6cQ2QJ3e2aQSjkvRoXjpZUx5akCRx4mohlwE6JFUkfHXrsl808oz9vVvUXCDhUJEIJ9g2cNI2roJ49g==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(36840700001)(46966006)(8936002)(55016003)(82310400004)(26005)(8676002)(336012)(7696005)(186003)(44832011)(5660300002)(966005)(6506007)(316002)(956004)(4326008)(81166007)(70586007)(86362001)(356005)(70206006)(508600001)(9686003)(2906002)(107886003)(36860700001)(83380400001)(47076005);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 14:18:25.0952 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1db7f529-a14c-4846-5576-08d9b98c6e8d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT013.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5830
Cc: tglx@linutronix.de, mingo@redhat.com
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

Hi,

On Mon, Dec 06, 2021 at 05:02:23PM +0000, Alexandru Elisei wrote:
> Userspace can assign a PMU to a VCPU with the KVM_ARM_VCPU_PMU_V3_SET_PMU
> device ioctl. If the VCPU is scheduled on a physical CPU which has a
> different PMU, the perf events needed to emulate a guest PMU won't be
> scheduled in and the guest performance counters will stop counting. Treat
> it as an userspace error and refuse to run the VCPU in this situation.
> 
> The VCPU is flagged as being scheduled on the wrong CPU in vcpu_load(), but
> the flag is cleared when the KVM_RUN enters the non-preemptible section
> instead of in vcpu_put(); this has been done on purpose so the error
> condition is communicated as soon as possible to userspace, otherwise
> vcpu_load() on the wrong CPU followed by a vcpu_put() would clear the flag.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> I agonized for hours about the best name for the VCPU flag and the
> accessors. If someone has a better idea, please tell me and I'll change
> them.
> 
>  Documentation/virt/kvm/devices/vcpu.rst |  6 +++++-
>  arch/arm64/include/asm/kvm_host.h       | 12 ++++++++++++
>  arch/arm64/include/uapi/asm/kvm.h       |  3 +++
>  arch/arm64/kvm/arm.c                    | 19 +++++++++++++++++++
>  arch/arm64/kvm/pmu-emul.c               |  1 +
>  5 files changed, 40 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index c82be5cbc268..9ae47b7c3652 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -128,7 +128,11 @@ systems where there are at least two CPU PMUs on the system.
>  
>  Note that KVM will not make any attempts to run the VCPU on the physical CPUs
>  associated with the PMU specified by this attribute. This is entirely left to
> -userspace.
> +userspace. However, attempting to run the VCPU on a physical CPU not supported
> +by the PMU will fail and KVM_RUN will return with
> +exit_reason = KVM_EXIT_FAIL_ENTRY and populate the fail_entry struct by setting
> +hardare_entry_failure_reason field to KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED and
> +the cpu field to the processor id.
>  
>  2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
>  =================================
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 2a5f7f38006f..0c453f2e48b6 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -385,6 +385,8 @@ struct kvm_vcpu_arch {
>  		u64 last_steal;
>  		gpa_t base;
>  	} steal;
> +
> +	cpumask_var_t supported_cpus;
>  };
>  
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> @@ -420,6 +422,7 @@ struct kvm_vcpu_arch {
>  #define KVM_ARM64_EXCEPT_MASK		(7 << 9) /* Target EL/MODE */
>  #define KVM_ARM64_DEBUG_STATE_SAVE_SPE	(1 << 12) /* Save SPE context if active  */
>  #define KVM_ARM64_DEBUG_STATE_SAVE_TRBE	(1 << 13) /* Save TRBE context if active  */
> +#define KVM_ARM64_ON_UNSUPPORTED_CPU	(1 << 14) /* Physical CPU not in supported_cpus */
>  
>  #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
>  				 KVM_GUESTDBG_USE_SW_BP | \
> @@ -460,6 +463,15 @@ struct kvm_vcpu_arch {
>  #define vcpu_has_ptrauth(vcpu)		false
>  #endif
>  
> +#define vcpu_on_unsupported_cpu(vcpu)					\
> +	((vcpu)->arch.flags & KVM_ARM64_ON_UNSUPPORTED_CPU)
> +
> +#define vcpu_set_on_unsupported_cpu(vcpu)				\
> +	((vcpu)->arch.flags |= KVM_ARM64_ON_UNSUPPORTED_CPU)
> +
> +#define vcpu_clear_on_unsupported_cpu(vcpu)				\
> +	((vcpu)->arch.flags &= ~KVM_ARM64_ON_UNSUPPORTED_CPU)
> +
>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.regs)
>  
>  /*
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 1d0a0a2a9711..d49f714f48e6 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -414,6 +414,9 @@ struct kvm_arm_copy_mte_tags {
>  #define KVM_PSCI_RET_INVAL		PSCI_RET_INVALID_PARAMS
>  #define KVM_PSCI_RET_DENIED		PSCI_RET_DENIED
>  
> +/* run->fail_entry.hardware_entry_failure_reason codes. */
> +#define KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED	(1ULL << 0)
> +
>  #endif
>  
>  #endif /* __ARM_KVM_H__ */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e4727dc771bf..1124c3efdd94 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -327,6 +327,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  
>  	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>  
> +	if (!zalloc_cpumask_var(&vcpu->arch.supported_cpus, GFP_KERNEL))
> +		return -ENOMEM;
> +	cpumask_copy(vcpu->arch.supported_cpus, cpu_possible_mask);
> +
>  	/* Set up the timer */
>  	kvm_timer_vcpu_init(vcpu);
>  
> @@ -354,6 +358,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.has_run_once && unlikely(!irqchip_in_kernel(vcpu->kvm)))
>  		static_branch_dec(&userspace_irqchip_in_use);
>  
> +	free_cpumask_var(vcpu->arch.supported_cpus);
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
>  	kvm_timer_vcpu_terminate(vcpu);
>  	kvm_pmu_vcpu_destroy(vcpu);
> @@ -432,6 +437,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	if (vcpu_has_ptrauth(vcpu))
>  		vcpu_ptrauth_disable(vcpu);
>  	kvm_arch_vcpu_load_debug_state_flags(vcpu);
> +
> +	if (!cpumask_test_cpu(smp_processor_id(), vcpu->arch.supported_cpus))
> +		vcpu_set_on_unsupported_cpu(vcpu);
>  }
>  
>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> @@ -822,6 +830,17 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  		 */
>  		preempt_disable();
>  
> +		if (unlikely(vcpu_on_unsupported_cpu(vcpu))) {
> +			vcpu_clear_on_unsupported_cpu(vcpu);
> +			run->exit_reason = KVM_EXIT_FAIL_ENTRY;
> +			run->fail_entry.hardware_entry_failure_reason
> +				= KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED;
> +			run->fail_entry.cpu = smp_processor_id();

I just realised that this is wrong for the same reason that KVM doesn't
clear the unsupported CPU flag on vcpu_put: a vcpu_put/load that happened
after the vcpu_load that set the flag and before preemption is disabled
could mean that now the thread is executing on a different physical CPU
than the physical CPU that caused the flag to be set. To make things worse,
this CPU might even be in supported_cpus, which would be extremely
confusing for someone trying to descipher what went wrong.

I see three solutions here:

1. Drop setting the fail_entry.cpu field.

2. Make vcpu_put clear the flag, which means that if the flag is set here
then the VCPU is definitely executing on the wrong physical CPU and
smp_processor_id() will be useful.

3. Carry the unsupported CPU ID information in a new field in struct
kvm_vcpu_arch.

I honestly don't have a preference. Maybe slightly towards solution number
2, as it makes the code symmetrical and removes the subtletly around when
the VCPU flag is cleared. But this would be done at the expense of
userspace possibly finding out a lot later (or never) that something went
wrong.

Thoughts?

Thanks,
Alex

> +			ret = 0;
> +			preempt_enable();
> +			break;
> +		}
> +
>  		kvm_pmu_flush_hwstate(vcpu);
>  
>  		local_irq_disable();
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 618138c5f792..471fe0f734ed 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -954,6 +954,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
>  		arm_pmu = entry->arm_pmu;
>  		if (arm_pmu->pmu.type == pmu_id) {
>  			kvm_pmu->arm_pmu = arm_pmu;
> +			cpumask_copy(vcpu->arch.supported_cpus, &arm_pmu->supported_cpus);
>  			ret = 0;
>  			goto out_unlock;
>  		}
> -- 
> 2.34.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
