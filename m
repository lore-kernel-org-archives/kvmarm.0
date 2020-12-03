Return-Path: <SRS0=mzwA=FH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD33C19437
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 14:46:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 287AF207D6
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 14:29:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 287AF207D6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 584A24B1E8;
	Thu,  3 Dec 2020 09:29:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hsHxpP5OKQWR; Thu,  3 Dec 2020 09:29:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EE094B1B4;
	Thu,  3 Dec 2020 09:29:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1CE34B0DE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 07:33:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h-RlgAxXfNzI for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2020 07:33:01 -0500 (EST)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A1E684B0DD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 07:33:00 -0500 (EST)
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.57])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4CmwG73DgxzQnJc;
 Thu,  3 Dec 2020 20:32:31 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Thu, 3 Dec 2020 20:32:55 +0800
Received: from [10.174.185.137] (10.174.185.137) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Thu, 3 Dec 2020 20:32:54 +0800
Subject: Re: [PATCH v13 05/15] iommu/smmuv3: Get prepared for nested stage
 support
To: Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
 <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, <will@kernel.org>,
 <joro@8bytes.org>, <maz@kernel.org>, <robin.murphy@arm.com>,
 <alex.williamson@redhat.com>
References: <20201118112151.25412-1-eric.auger@redhat.com>
 <20201118112151.25412-6-eric.auger@redhat.com>
From: Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <a40b90bd-6756-c8cc-b455-c093d16d35f5@huawei.com>
Date: Thu, 3 Dec 2020 20:32:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201118112151.25412-6-eric.auger@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.137]
X-ClientProxiedBy: dggeme706-chm.china.huawei.com (10.1.199.102) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Thu, 03 Dec 2020 09:29:05 -0500
Cc: jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
 nicoleotsuka@gmail.com, vivek.gautam@arm.com, yi.l.liu@intel.com,
 zhangfei.gao@linaro.org
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
Content-Type: multipart/mixed; boundary="===============8747211234052994714=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============8747211234052994714==
Content-Type: multipart/alternative;
	boundary="------------2E2FC73B722F3D2CE7CFEA1A"
Content-Language: en-US

--------------2E2FC73B722F3D2CE7CFEA1A
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

Hi Eric,

On 2020/11/18 19:21, Eric Auger wrote:
> When nested stage translation is setup, both s1_cfg and
> s2_cfg are set.
>
> We introduce a new smmu domain abort field that will be set
> upon guest stage1 configuration passing.
>
> arm_smmu_write_strtab_ent() is modified to write both stage
> fields in the STE and deal with the abort field.
>
> In nested mode, only stage 2 is "finalized" as the host does
> not own/configure the stage 1 context descriptor; guest does.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>
> ---
> v10 -> v11:
> - Fix an issue reported by Shameer when switching from with vSMMU
>    to without vSMMU. Despite the spec does not seem to mention it
>    seems to be needed to reset the 2 high 64b when switching from
>    S1+S2 cfg to S1 only. Especially dst[3] needs to be reset (S2TTB).
>    On some implementations, if the S2TTB is not reset, this causes
>    a C_BAD_STE error
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 64 +++++++++++++++++----
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 +
>   2 files changed, 56 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 18ac5af1b284..412ea1bafa50 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1181,8 +1181,10 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>   	 * three cases at the moment:
Now, it should be *five cases*.
>   	 *
>   	 * 1. Invalid (all zero) -> bypass/fault (init)
> -	 * 2. Bypass/fault -> translation/bypass (attach)
> -	 * 3. Translation/bypass -> bypass/fault (detach)
> +	 * 2. Bypass/fault -> single stage translation/bypass (attach)
> +	 * 3. Single or nested stage Translation/bypass -> bypass/fault (detach)
> +	 * 4. S2 -> S1 + S2 (attach_pasid_table)

I was testing this series on one of our hardware board with SMMUv3. And 
I found while trying to /"//attach_pasid_table//"/,

the sequence of STE (host) config(bit[3:1]) is /"S2->abort->S1 + S2"/. 
Because the maintenance is /"Write everything apart///

/from dword 0, sync, write dword 0, sync"/ when we update the STE 
(guest). Dose the sequence meet your expectation?

> +	 * 5. S1 + S2 -> S2 (detach_pasid_table)
>   	 *
>   	 * Given that we can't update the STE atomically and the SMMU
>   	 * doesn't read the thing in a defined order, that leaves us
> @@ -1193,7 +1195,8 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>   	 * 3. Update Config, sync
>   	 */
>   	u64 val = le64_to_cpu(dst[0]);
> -	bool ste_live = false;
> +	bool s1_live = false, s2_live = false, ste_live;
> +	bool abort, nested = false, translate = false;
>   	struct arm_smmu_device *smmu = NULL;
>   	struct arm_smmu_s1_cfg *s1_cfg;
>   	struct arm_smmu_s2_cfg *s2_cfg;
> @@ -1233,6 +1236,8 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>   		default:
>   			break;
>   		}
> +		nested = s1_cfg->set && s2_cfg->set;
> +		translate = s1_cfg->set || s2_cfg->set;
>   	}
>   
>   	if (val & STRTAB_STE_0_V) {
> @@ -1240,23 +1245,36 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>   		case STRTAB_STE_0_CFG_BYPASS:
>   			break;
>   		case STRTAB_STE_0_CFG_S1_TRANS:
> +			s1_live = true;
> +			break;
>   		case STRTAB_STE_0_CFG_S2_TRANS:
> -			ste_live = true;
> +			s2_live = true;
> +			break;
> +		case STRTAB_STE_0_CFG_NESTED:
> +			s1_live = true;
> +			s2_live = true;
>   			break;
>   		case STRTAB_STE_0_CFG_ABORT:
> -			BUG_ON(!disable_bypass);
>   			break;
>   		default:
>   			BUG(); /* STE corruption */
>   		}
>   	}
>   
> +	ste_live = s1_live || s2_live;
> +
>   	/* Nuke the existing STE_0 value, as we're going to rewrite it */
>   	val = STRTAB_STE_0_V;
>   
>   	/* Bypass/fault */
> -	if (!smmu_domain || !(s1_cfg->set || s2_cfg->set)) {
> -		if (!smmu_domain && disable_bypass)
> +
> +	if (!smmu_domain)
> +		abort = disable_bypass;
> +	else
> +		abort = smmu_domain->abort;
> +
> +	if (abort || !translate) {
> +		if (abort)
>   			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
>   		else
>   			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
> @@ -1274,8 +1292,16 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>   		return;
>   	}
>   
> +	BUG_ON(ste_live && !nested);
> +
> +	if (ste_live) {
> +		/* First invalidate the live STE */
> +		dst[0] = cpu_to_le64(STRTAB_STE_0_CFG_ABORT);
> +		arm_smmu_sync_ste_for_sid(smmu, sid);
> +	}
> +
>   	if (s1_cfg->set) {
> -		BUG_ON(ste_live);
> +		BUG_ON(s1_live);
>   		dst[1] = cpu_to_le64(
>   			 FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
>   			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
> @@ -1294,7 +1320,14 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>   	}
>   
>   	if (s2_cfg->set) {
> -		BUG_ON(ste_live);
> +		u64 vttbr = s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK;
> +
> +		if (s2_live) {
> +			u64 s2ttb = le64_to_cpu(dst[3] & STRTAB_STE_3_S2TTB_MASK);
> +
> +			BUG_ON(s2ttb != vttbr);
> +		}
> +
>   		dst[2] = cpu_to_le64(
>   			 FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
>   			 FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
> @@ -1304,9 +1337,12 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>   			 STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2AA64 |
>   			 STRTAB_STE_2_S2R);
>   
> -		dst[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
> +		dst[3] = cpu_to_le64(vttbr);
>   
>   		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS);
> +	} else {
> +		dst[2] = 0;
> +		dst[3] = 0;
>   	}
>   
>   	if (master->ats_enabled)
> @@ -1982,6 +2018,14 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
>   		return 0;
>   	}
>   
> +	if (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED &&
> +	    (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1) ||
> +	     !(smmu->features & ARM_SMMU_FEAT_TRANS_S2))) {
> +		dev_info(smmu_domain->smmu->dev,
> +			 "does not implement two stages\n");
> +		return -EINVAL;
> +	}
> +
>   	/* Restrict the stage to what we can actually support */
>   	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1))
>   		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 07f59252dd21..269779dee8d1 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -206,6 +206,7 @@
>   #define STRTAB_STE_0_CFG_BYPASS		4
>   #define STRTAB_STE_0_CFG_S1_TRANS	5
>   #define STRTAB_STE_0_CFG_S2_TRANS	6
> +#define STRTAB_STE_0_CFG_NESTED		7
>   
>   #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
>   #define STRTAB_STE_0_S1FMT_LINEAR	0
> @@ -682,6 +683,7 @@ struct arm_smmu_domain {
>   	enum arm_smmu_domain_stage	stage;
>   	struct arm_smmu_s1_cfg	s1_cfg;
>   	struct arm_smmu_s2_cfg	s2_cfg;
> +	bool				abort;
>   
>   	struct iommu_domain		domain;

Thanks,

Kunkun Jiang


--------------2E2FC73B722F3D2CE7CFEA1A
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p>Hi Eric,<br>
    </p>
    <div class="moz-cite-prefix">On 2020/11/18 19:21, Eric Auger wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20201118112151.25412-6-eric.auger@redhat.com">
      <pre class="moz-quote-pre" wrap="">When nested stage translation is setup, both s1_cfg and
s2_cfg are set.

We introduce a new smmu domain abort field that will be set
upon guest stage1 configuration passing.

arm_smmu_write_strtab_ent() is modified to write both stage
fields in the STE and deal with the abort field.

In nested mode, only stage 2 is "finalized" as the host does
not own/configure the stage 1 context descriptor; guest does.

Signed-off-by: Eric Auger <a class="moz-txt-link-rfc2396E" href="mailto:eric.auger@redhat.com">&lt;eric.auger@redhat.com&gt;</a>

---
v10 -&gt; v11:
- Fix an issue reported by Shameer when switching from with vSMMU
  to without vSMMU. Despite the spec does not seem to mention it
  seems to be needed to reset the 2 high 64b when switching from
  S1+S2 cfg to S1 only. Especially dst[3] needs to be reset (S2TTB).
  On some implementations, if the S2TTB is not reset, this causes
  a C_BAD_STE error
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 64 +++++++++++++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 +
 2 files changed, 56 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 18ac5af1b284..412ea1bafa50 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1181,8 +1181,10 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	 * three cases at the moment:</pre>
    </blockquote>
    Now, it should be <b>five cases</b>.<br>
    <blockquote type="cite"
      cite="mid:20201118112151.25412-6-eric.auger@redhat.com">
      <pre class="moz-quote-pre" wrap="">
 	 *
 	 * 1. Invalid (all zero) -&gt; bypass/fault (init)
-	 * 2. Bypass/fault -&gt; translation/bypass (attach)
-	 * 3. Translation/bypass -&gt; bypass/fault (detach)
+	 * 2. Bypass/fault -&gt; single stage translation/bypass (attach)
+	 * 3. Single or nested stage Translation/bypass -&gt; bypass/fault (detach)
+	 * 4. S2 -&gt; S1 + S2 (attach_pasid_table)</pre>
    </blockquote>
    <p>I was testing this series on one of our hardware board with
      SMMUv3. And I found while trying to <i>"</i><i>attach_pasid_table</i><i>"</i>,
      <br>
    </p>
    <p>the sequence of STE (host) config(bit[3:1]) is <i>"S2-&gt;abort-&gt;S1
        + S2"</i>. Because the maintenance is  <i>"Write everything
        apart</i><i></i></p>
    <p><i>from dword 0, sync, write dword 0, sync"</i> when we update
      the STE (guest). Dose the sequence meet your expectation?<br>
    </p>
    <blockquote type="cite"
      cite="mid:20201118112151.25412-6-eric.auger@redhat.com">
      <pre class="moz-quote-pre" wrap="">
+	 * 5. S1 + S2 -&gt; S2 (detach_pasid_table)
 	 *
 	 * Given that we can't update the STE atomically and the SMMU
 	 * doesn't read the thing in a defined order, that leaves us
@@ -1193,7 +1195,8 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	 * 3. Update Config, sync
 	 */
 	u64 val = le64_to_cpu(dst[0]);
-	bool ste_live = false;
+	bool s1_live = false, s2_live = false, ste_live;
+	bool abort, nested = false, translate = false;
 	struct arm_smmu_device *smmu = NULL;
 	struct arm_smmu_s1_cfg *s1_cfg;
 	struct arm_smmu_s2_cfg *s2_cfg;
@@ -1233,6 +1236,8 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		default:
 			break;
 		}
+		nested = s1_cfg-&gt;set &amp;&amp; s2_cfg-&gt;set;
+		translate = s1_cfg-&gt;set || s2_cfg-&gt;set;
 	}
 
 	if (val &amp; STRTAB_STE_0_V) {
@@ -1240,23 +1245,36 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		case STRTAB_STE_0_CFG_BYPASS:
 			break;
 		case STRTAB_STE_0_CFG_S1_TRANS:
+			s1_live = true;
+			break;
 		case STRTAB_STE_0_CFG_S2_TRANS:
-			ste_live = true;
+			s2_live = true;
+			break;
+		case STRTAB_STE_0_CFG_NESTED:
+			s1_live = true;
+			s2_live = true;
 			break;
 		case STRTAB_STE_0_CFG_ABORT:
-			BUG_ON(!disable_bypass);
 			break;
 		default:
 			BUG(); /* STE corruption */
 		}
 	}
 
+	ste_live = s1_live || s2_live;
+
 	/* Nuke the existing STE_0 value, as we're going to rewrite it */
 	val = STRTAB_STE_0_V;
 
 	/* Bypass/fault */
-	if (!smmu_domain || !(s1_cfg-&gt;set || s2_cfg-&gt;set)) {
-		if (!smmu_domain &amp;&amp; disable_bypass)
+
+	if (!smmu_domain)
+		abort = disable_bypass;
+	else
+		abort = smmu_domain-&gt;abort;
+
+	if (abort || !translate) {
+		if (abort)
 			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
 		else
 			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
@@ -1274,8 +1292,16 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		return;
 	}
 
+	BUG_ON(ste_live &amp;&amp; !nested);
+
+	if (ste_live) {
+		/* First invalidate the live STE */
+		dst[0] = cpu_to_le64(STRTAB_STE_0_CFG_ABORT);
+		arm_smmu_sync_ste_for_sid(smmu, sid);
+	}
+
 	if (s1_cfg-&gt;set) {
-		BUG_ON(ste_live);
+		BUG_ON(s1_live);
 		dst[1] = cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
 			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
@@ -1294,7 +1320,14 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	}
 
 	if (s2_cfg-&gt;set) {
-		BUG_ON(ste_live);
+		u64 vttbr = s2_cfg-&gt;vttbr &amp; STRTAB_STE_3_S2TTB_MASK;
+
+		if (s2_live) {
+			u64 s2ttb = le64_to_cpu(dst[3] &amp; STRTAB_STE_3_S2TTB_MASK);
+
+			BUG_ON(s2ttb != vttbr);
+		}
+
 		dst[2] = cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg-&gt;vmid) |
 			 FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg-&gt;vtcr) |
@@ -1304,9 +1337,12 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 			 STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2AA64 |
 			 STRTAB_STE_2_S2R);
 
-		dst[3] = cpu_to_le64(s2_cfg-&gt;vttbr &amp; STRTAB_STE_3_S2TTB_MASK);
+		dst[3] = cpu_to_le64(vttbr);
 
 		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS);
+	} else {
+		dst[2] = 0;
+		dst[3] = 0;
 	}
 
 	if (master-&gt;ats_enabled)
@@ -1982,6 +2018,14 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
 		return 0;
 	}
 
+	if (smmu_domain-&gt;stage == ARM_SMMU_DOMAIN_NESTED &amp;&amp;
+	    (!(smmu-&gt;features &amp; ARM_SMMU_FEAT_TRANS_S1) ||
+	     !(smmu-&gt;features &amp; ARM_SMMU_FEAT_TRANS_S2))) {
+		dev_info(smmu_domain-&gt;smmu-&gt;dev,
+			 "does not implement two stages\n");
+		return -EINVAL;
+	}
+
 	/* Restrict the stage to what we can actually support */
 	if (!(smmu-&gt;features &amp; ARM_SMMU_FEAT_TRANS_S1))
 		smmu_domain-&gt;stage = ARM_SMMU_DOMAIN_S2;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 07f59252dd21..269779dee8d1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -206,6 +206,7 @@
 #define STRTAB_STE_0_CFG_BYPASS		4
 #define STRTAB_STE_0_CFG_S1_TRANS	5
 #define STRTAB_STE_0_CFG_S2_TRANS	6
+#define STRTAB_STE_0_CFG_NESTED		7
 
 #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
 #define STRTAB_STE_0_S1FMT_LINEAR	0
@@ -682,6 +683,7 @@ struct arm_smmu_domain {
 	enum arm_smmu_domain_stage	stage;
 	struct arm_smmu_s1_cfg	s1_cfg;
 	struct arm_smmu_s2_cfg	s2_cfg;
+	bool				abort;
 
 	struct iommu_domain		domain;
</pre>
    </blockquote>
    <p>Thanks,</p>
    <p>Kunkun Jiang<br>
    </p>
  </body>
</html>

--------------2E2FC73B722F3D2CE7CFEA1A--

--===============8747211234052994714==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8747211234052994714==--
