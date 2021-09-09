Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D142DC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 18:22:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B7146113E
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 18:22:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4B7146113E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B43204B173;
	Thu,  9 Sep 2021 14:22:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3WJ8mLVpbx2t; Thu,  9 Sep 2021 14:22:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F1CF4B17E;
	Thu,  9 Sep 2021 14:22:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55FF84B173
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 14:22:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tb9Ska8nR0tU for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 14:22:32 -0400 (EDT)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 278F64B163
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 14:22:32 -0400 (EDT)
Received: by mail-pj1-f44.google.com with SMTP id
 m21-20020a17090a859500b00197688449c4so2115917pjn.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 11:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=v5aoMvyRKi+uwVGCkGUcHFzKL5pUxSLVstbkYTx45wk=;
 b=FstLpK6G0tmuHci4pYVATcmWwKye5FzpR+EieVLcffkmPn8eysFWwzZaWPJwx52IFD
 2wHcfzW66NsVKR52BscmPxMS8YMTfYazojM0DGMSZ56Kn+nn/f25ebTQw/tt8YyDZPmV
 QOg2aRdhoknIeNo33yy0jtOOWEBe84ysLH3wlx4AIVECk8MB7XBlwe3oad5HZDOcu1Ol
 LeaAndPNzuYfax3uPFSF217zGF533UsLKbA5HYTHHFkS3hrvjDnxHi/TvUgZEMijUsWJ
 IYYHny4wdOiR6pVlOM5G+LvctB776ulrnuCA4xtB7rvsRcUye5CIvAJK9M083clqkRwk
 DCZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=v5aoMvyRKi+uwVGCkGUcHFzKL5pUxSLVstbkYTx45wk=;
 b=YSSKggg0I93SHlIutjlOzEdAKhhUKX7LweKVnrtHQ3JIpjqGI8n5WUud8ajQ4NNCmG
 Q10fl8Yxm/lmHjHOnENaEFcPwFlMH/r3vKXMYh96xeDpmWnpI0ht3vm4qTVPtWFI80yP
 iVQl22dgAWMUiU/w4Rn2/Yk/QyObHl2k7vdWmy8m1DfSexZYf/otkFaVl1Lkp0eZ0kI8
 xz5YhQ2YZ6j49IkpRTDn0SQcxzLJEdTzLy0DgWHWgLe4IVYwREC/1X2QDwikqDUNnAmG
 PB/+LZG6RbfnmdMfMaGQDvkL1lGt2IYwWQPdMk4JFYE3+wtMqFfqx4ZK+98j3NMLbjwd
 uEuQ==
X-Gm-Message-State: AOAM5308VaCITagLU+5OD4JChJ9xInmJPwqAWWRzN/OLEcgZxuSuJvPh
 z8a8hTT5HIfS/I5gU6B2TpZwEQ==
X-Google-Smtp-Source: ABdhPJx5Ks+gSeRKyuJ4/FwCyKIxKEprs2/9hZ5KzGomHq/lkLr9u/qE6IwAFLOBPC4wnnYd4UAxZg==
X-Received: by 2002:a17:90a:5511:: with SMTP id
 b17mr5009368pji.222.1631211751120; 
 Thu, 09 Sep 2021 11:22:31 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id h7sm3010634pfk.96.2021.09.09.11.22.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 09 Sep 2021 11:22:30 -0700 (PDT)
Date: Thu, 9 Sep 2021 11:22:27 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: test for vgic redist above
 the VM IPA size
Message-ID: <YTpQ4y37RhaQTJ3m@google.com>
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-3-ricarkol@google.com>
 <83282104-ca04-c4f5-3570-c884a22ab667@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <83282104-ca04-c4f5-3570-c884a22ab667@redhat.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, shuah@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 09, 2021 at 03:54:31PM +0200, Eric Auger wrote:
> Hi Ricardo,
> 
> On 9/8/21 11:03 PM, Ricardo Koller wrote:
> > This test attempts (and fails) to set a redistributor region using the
> > legacy KVM_VGIC_V3_ADDR_TYPE_REDIST that's partially above the
> > VM-specified IPA size.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/vgic_init.c | 44 +++++++++++++++++++
> >  1 file changed, 44 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > index 623f31a14326..6dd7b5e91421 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > @@ -285,6 +285,49 @@ static void test_vcpus_then_vgic(void)
> >  	vm_gic_destroy(&v);
> >  }
> >  
> > +static void test_redist_above_vm_pa_bits(enum vm_guest_mode mode)
> > +{
> > +	struct vm_gic v;
> > +	int ret, i;
> > +	uint32_t vcpuids[] = { 1, 2, 3, 4, };
> > +	int pa_bits = vm_guest_mode_params[mode].pa_bits;
> > +	uint64_t addr, psize = 1ULL << pa_bits;
> > +
> > +	/* Add vcpu 1 */
> > +	v.vm = vm_create_with_vcpus(mode, 1, DEFAULT_GUEST_PHY_PAGES,
> > +				    0, 0, guest_code, vcpuids);
> > +	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> > +
> > +	/* Set space for half a redist, we have 1 vcpu, so this fails. */
> > +	addr = psize - 0x10000;
> > +	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> > +	TEST_ASSERT(ret && errno == EINVAL, "not enough space for one redist");
> > +
> > +	/* Set space for 3 redists, we have 1 vcpu, so this succeeds. */
> > +	addr = psize - (3 * 2 * 0x10000);
> > +	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> 
> I think you need to test both the old API (KVM_VGIC_V3_ADDR_TYPE_REDIST)
> and the new one (KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION).
> 
> Can't you integrate those new checks in existing tests,
> subtest_redist_regions() and subtest_dist_rdist() which already tests
> base addr beyond IPA limit (but not range end unfortunately). look for
> E2BIG.
> 

Had some issues adapting subtest_dist_rdist() as the IPA range check for
ADDR_TYPE_REDIST is done at 1st vcpu run.  subtest_dist_rdist() is
already used to set overlapping dist/redist regions, which is then
checked to generate EINVAL on 1st vcpu run. If subtest_dist_rdist() is
also used to set the redist region above phys_size, then there won't be
a way of checking that the vcpu run fails because of both the overlap
and IPA issue.  It was simpler and cleaner to just add a new function
for the ADDR_TYPE_REDIST IPA range test.  Will adapt
subtest_redist_regions() as the check for ADDR_TYPE_REDIST_REGION can be
done when setting the regions.

Related Question:

Both the KVM_VGIC_V3_ADDR_TYPE_REDIST and KVM_RUN currently return
EINVAL with my proposed change (not E2BIG). I will change
KVM_VGIC_V3_ADDR_TYPE_REDIST to fail with E2BIG, but will leave KVM_RUN
failing with EINVAL.  Would you say that's the correct behavior?

Thanks,
Ricardo

> Thanks
> 
> Eric
> > +
> > +	addr = 0x00000;
> > +	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +			KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
> > +
> > +	/* Add three vcpus (2, 3, 4). */
> > +	for (i = 1; i < 4; ++i)
> > +		vm_vcpu_add_default(v.vm, vcpuids[i], guest_code);
> > +
> > +	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> > +			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> > +
> > +	/* Attempt to run a vcpu without enough redist space. */
> > +	ret = run_vcpu(v.vm, vcpuids[3]);
> > +	TEST_ASSERT(ret && errno == EINVAL,
> > +			"redist base+size above IPA detected on 1st vcpu run");
> > +
> > +	vm_gic_destroy(&v);
> > +}
> > +
> >  static void test_new_redist_regions(void)
> >  {
> >  	void *dummy = NULL;
> > @@ -542,6 +585,7 @@ int main(int ac, char **av)
> >  	test_kvm_device();
> >  	test_vcpus_then_vgic();
> >  	test_vgic_then_vcpus();
> > +	test_redist_above_vm_pa_bits(VM_MODE_DEFAULT);
> >  	test_new_redist_regions();
> >  	test_typer_accesses();
> >  	test_last_bit_redist_regions();
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
