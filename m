Return-Path: <SRS0=OV02=3L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D3DC32771
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jan 2020 08:03:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 864E924655
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jan 2020 08:03:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hTD00hvk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 864E924655
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E28A94AEA0;
	Wed, 22 Jan 2020 03:03:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HNrZcwJQ6+CV; Wed, 22 Jan 2020 03:03:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 843DF4AC6C;
	Wed, 22 Jan 2020 03:03:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AC744A98A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 18:07:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bh1Ifd2mB0Lp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 18:07:24 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C8074A65C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 18:07:24 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579648044;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=f2cyYrzZjaObk0GaFZuKu7ZNaVVTKctI9uxWbPIKw20=;
 b=hTD00hvkzdOVv+M6gS7u6YbEXrP+8J21YJ6YFFn+BUPVGgIDbrKFL+0gbZ8FhLyZUjjPz6
 ix05arQORmVIfieng23rYe/baPLiyib+uWwbcQrRWao3MErk0fbhTGwxtYLC8djuvhLCZC
 WdES0ETRIxFXhIw14NchkWnzXTLRsu0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-q6JAYjFQM_eyb96_RtIPPg-1; Tue, 21 Jan 2020 18:07:19 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AAE2107ACC9;
 Tue, 21 Jan 2020 23:07:18 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-63.bne.redhat.com [10.64.54.63])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B1E9D5DA2C;
 Tue, 21 Jan 2020 23:07:14 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm/arm64: Fix young bit from mmu notifier
To: Marc Zyngier <maz@kernel.org>
References: <20200121055659.19560-1-gshan@redhat.com>
 <55ae5a0f91f2e675a4e71d83bef9d911@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <421c8827-4201-9e07-7d7e-377a8ee665c1@redhat.com>
Date: Wed, 22 Jan 2020 10:07:12 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <55ae5a0f91f2e675a4e71d83bef9d911@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: q6JAYjFQM_eyb96_RtIPPg-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Wed, 22 Jan 2020 03:03:08 -0500
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 1/22/20 12:28 AM, Marc Zyngier wrote:
> On 2020-01-21 05:56, Gavin Shan wrote:
>> kvm_test_age_hva() is called upon mmu_notifier_test_young(), but wrong
>> address range has been passed to handle_hva_to_gpa(). With the wrong
>> address range, no young bits will be checked in handle_hva_to_gpa().
>> It means zero is always returned from mmu_notifier_test_young().
>>
>> This fixes the issue by passing correct address range to the underly
>> function handle_hva_to_gpa(), so that the hardware young (access) bit
>> will be visited.
>>
>> Cc: stable@vger.kernel.org # v4.1+
>> Fixes: 35307b9a5f7e ("arm/arm64: KVM: Implement Stage-2 page aging")
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>> =A0virt/kvm/arm/mmu.c | 3 ++-
>> =A01 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 0b32a904a1bb..a2777efb558e 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -2147,7 +2147,8 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned lon=
g hva)
>> =A0=A0=A0=A0 if (!kvm->arch.pgd)
>> =A0=A0=A0=A0=A0=A0=A0=A0 return 0;
>> =A0=A0=A0=A0 trace_kvm_test_age_hva(hva);
>> -=A0=A0=A0 return handle_hva_to_gpa(kvm, hva, hva, kvm_test_age_hva_hand=
ler, NULL);
>> +=A0=A0=A0 return handle_hva_to_gpa(kvm, hva, hva + PAGE_SIZE,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 kvm_test_age_hva_handl=
er, NULL);
>> =A0}
>>
>> =A0void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu)
> =

> I knew this start/end thing (instead of start/size) would bite us
> one of these days. Terribly embarrassing. On the other hand, who
> really wants to swap things out? ;-)
> =

> Out of curiosity, how did you find this one?
> =


Well, it's hard to tell who really wants to swap things out. Something I
was involved previously: user daemon is started to scan the accessed pages
periodically, in order to determine the least accessed pages. These least
access anonymous pages are migrated to low-cost storage (e.g. NVDIMM). This
helps on balance of performance and cost.

It's found when reading code. After that, I wrote some code (as below) to
double confirm:

    (1) locate qemu process and the corresponding vma because the VM is sta=
rted
        with "mem-path=3D/tmp/virtiofs/backup-file". "backup-file" is the k=
ey in
        the location.
    (2) iterate the virtual space of the vma by mmu_notifier_test_young(), =
none
        of return values is 1 (accessed). It seems it's not correct.

With the patch applied and rerun above code, mmu_notifier_test_young() retu=
rns
1 (accessed) on some pages.

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
