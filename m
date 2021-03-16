Return-Path: <SRS0=Oq5u=IO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE8BC433E0
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 03:52:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D197650CA
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 03:52:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D197650CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B49DE4B38A;
	Mon, 15 Mar 2021 23:52:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5QpmTXXcb82h; Mon, 15 Mar 2021 23:52:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C28A4B38B;
	Mon, 15 Mar 2021 23:52:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D58A94B370
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 23:52:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZYqIBTr+XIQU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 23:52:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAEC54B369
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 23:52:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615866759;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=V40kaFfpUEyV4ZKdYetesb/NkWxPeo4GP3hb5Jwdckc=;
 b=dFks9dscLGWEDOl1HV1ua/16r4UEqq0oNBQ1s5phU1GLKfDbuJDTFBYkfFM3fPunEmrM/R
 kBFxw07O6ybDzeR4aqYDzFtnCorgycaqYEdP0LZ9S86VzV3hz/16OyzApSU3M/Jq3rBjtD
 r+3uRv0Sq4RwvFb8hfbSCzpR/Tit+aI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-Pu0pn-o-OkaHyKopJf4Ndg-1; Mon, 15 Mar 2021 23:52:37 -0400
X-MC-Unique: Pu0pn-o-OkaHyKopJf4Ndg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DA8239381;
 Tue, 16 Mar 2021 03:52:36 +0000 (UTC)
Received: from [10.64.54.175] (vpn2-54-175.bne.redhat.com [10.64.54.175])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 46FE461F5C;
 Tue, 16 Mar 2021 03:52:32 +0000 (UTC)
Subject: Re: [PATCH 2/4] KVM: arm64: Use find_vma_intersection()
From: Gavin Shan <gshan@redhat.com>
To: Keqian Zhu <zhukeqian1@huawei.com>, kvmarm@lists.cs.columbia.edu
References: <20210315041844.64915-1-gshan@redhat.com>
 <20210315041844.64915-3-gshan@redhat.com>
 <65dfdca3-af94-7d5a-86fe-24825301655b@huawei.com>
 <2eef2b42-13bd-2414-f748-551039677bf5@redhat.com>
Message-ID: <d46320a2-7381-a46a-42e5-6bfa75321d31@redhat.com>
Date: Tue, 16 Mar 2021 14:52:28 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <2eef2b42-13bd-2414-f748-551039677bf5@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: maz@kernel.org, will@kernel.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com
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

Hi Keqian,

On 3/15/21 8:42 PM, Gavin Shan wrote:
> On 3/15/21 7:04 PM, Keqian Zhu wrote:
>> On 2021/3/15 12:18, Gavin Shan wrote:
>>> find_vma_intersection() has been existing to search the intersected
>>> vma. This uses the function where it's applicable, to simplify the
>>> code.
>>>
>>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>>> ---
>>> =A0 arch/arm64/kvm/mmu.c | 10 ++++++----
>>> =A0 1 file changed, 6 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index 84e70f953de6..286b603ed0d3 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -421,10 +421,11 @@ static void stage2_unmap_memslot(struct kvm *kvm,
>>> =A0=A0=A0=A0=A0=A0 *=A0=A0=A0=A0 +-------------------------------------=
-------+
>>> =A0=A0=A0=A0=A0=A0 */
>>> =A0=A0=A0=A0=A0 do {
>>> -=A0=A0=A0=A0=A0=A0=A0 struct vm_area_struct *vma =3D find_vma(current-=
>mm, hva);
>>> +=A0=A0=A0=A0=A0=A0=A0 struct vm_area_struct *vma;
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 hva_t vm_start, vm_end;
>>> -=A0=A0=A0=A0=A0=A0=A0 if (!vma || vma->vm_start >=3D reg_end)
>>> +=A0=A0=A0=A0=A0=A0=A0 vma =3D find_vma_intersection(current->mm, hva, =
reg_end);
>> Nit: Keep a same style may be better(Assign vma when declare it).
>> Other looks good to me.
>>
> =

> Yeah, I agree. I will adjust the code in v2 and included your r-b.
> Thanks for your time to review.
> =


After rechecking the code, I think it'd better to keep current style
because there is a follow-on validation on @vma. Keeping them together
seems a good idea. I think it wouldn't a big deal to you. So I will
keep current style with your r-b in v2.

	vma =3D find_vma_intersection(current->mm, hva, reg_end);
         if (!vma)
              break;
Thanks,
Gavin
  =

>>> +=A0=A0=A0=A0=A0=A0=A0 if (!vma)
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 /*
>>> @@ -1330,10 +1331,11 @@ int kvm_arch_prepare_memory_region(struct kvm *=
kvm,
>>> =A0=A0=A0=A0=A0=A0 *=A0=A0=A0=A0 +-------------------------------------=
-------+
>>> =A0=A0=A0=A0=A0=A0 */
>>> =A0=A0=A0=A0=A0 do {
>>> -=A0=A0=A0=A0=A0=A0=A0 struct vm_area_struct *vma =3D find_vma(current-=
>mm, hva);
>>> +=A0=A0=A0=A0=A0=A0=A0 struct vm_area_struct *vma;
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 hva_t vm_start, vm_end;
>>> -=A0=A0=A0=A0=A0=A0=A0 if (!vma || vma->vm_start >=3D reg_end)
>>> +=A0=A0=A0=A0=A0=A0=A0 vma =3D find_vma_intersection(current->mm, hva, =
reg_end);
>>> +=A0=A0=A0=A0=A0=A0=A0 if (!vma)
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 /*
>>>
>>
> =


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
