Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1242FC4332F
	for <kvmarm@archiver.kernel.org>; Fri, 11 Nov 2022 23:43:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 752834B813;
	Fri, 11 Nov 2022 18:43:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QEs84TZN0-Lr; Fri, 11 Nov 2022 18:43:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0426E4B7FD;
	Fri, 11 Nov 2022 18:43:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E96994B7E8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2022 18:43:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2uBdCwP-UwZG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Nov 2022 18:43:44 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 931674B78C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2022 18:43:44 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1668210224;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=SL1C4N4MhlJR5mFY0fBJfzPIf2BifFdJBYUYia1GgkQ=;
 b=Rpo2xd6UaG8cvnLmcNaJlIlkRtgny+Vo4x3b1fS0JZpVECLOxA1sCYwEkpmajdTxKKAh/3
 QckRGyYPhtQjUBxzSDTkxEC9krHPUFlaH30YpPKhaIrGDSI0r2b94723wyZVYR/UfU12PO
 xnr9JYTKrtAexev4gjw1WQK8sab+eSI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-FlL4DXDBPImPH3-FbfKO2Q-1; Fri, 11 Nov 2022 18:43:41 -0500
X-MC-Unique: FlL4DXDBPImPH3-FbfKO2Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D6D729DD993;
 Fri, 11 Nov 2022 23:43:40 +0000 (UTC)
Received: from [10.67.24.81] (unknown [10.67.24.81])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B11E140EBF5;
 Fri, 11 Nov 2022 23:43:31 +0000 (UTC)
Subject: Re: [PATCH v10 3/7] KVM: Support dirty ring in conjunction with bitmap
To: Sean Christopherson <seanjc@google.com>
References: <20221110104914.31280-1-gshan@redhat.com>
 <20221110104914.31280-4-gshan@redhat.com> <Y20q3lq5oc2gAqr+@google.com>
 <1cfa0286-9a42-edd9-beab-02f95fc440ad@redhat.com>
 <86h6z5plhz.wl-maz@kernel.org>
 <d11043b5-ff65-0461-146e-6353cf66f737@redhat.com>
 <Y27T+1Y8w0U6j63k@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <c95c9912-0ca9-88e5-8b51-0c6826cf49b9@redhat.com>
Date: Sat, 12 Nov 2022 07:43:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y27T+1Y8w0U6j63k@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, bgardon@google.com,
 andrew.jones@linux.dev, dmatlack@google.com, will@kernel.org,
 shan.gavin@gmail.com, catalin.marinas@arm.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Sean,

On 11/12/22 7:00 AM, Sean Christopherson wrote:
> On Sat, Nov 12, 2022, Gavin Shan wrote:
>> On 11/11/22 11:19 PM, Marc Zyngier wrote:
>>> On Thu, 10 Nov 2022 23:47:41 +0000,
>>> Gavin Shan <gshan@redhat.com> wrote:
>>> But that I don't get. Or rather, I don't get the commit message that
>>> matches this hunk. Do we want to catch the case where all of the
>>> following are true:
>>>
>>> - we don't have a vcpu,
>>> - we're allowed to log non-vcpu dirtying
>>> - we *only* have the ring?
> 
> As written, no, because the resulting WARN will be user-triggerable.  As mentioned
> earlier in the thread[*], if ARM rejects KVM_DEV_ARM_ITS_SAVE_TABLES when dirty
> logging is enabled with a bitmap, then this code can WARN.
> 

I assume you're saying to reject the command when dirty ring is enabled __without__
a bitmap. vgic/its is the upper layer of dirty dirty. To me, it's a bad idea for the
upper layer needs to worry too much about the lower layer.

>>> If so, can we please capture that in the commit message?
>>>
>>
>> Nice catch! This particular case needs to be warned explicitly. Without
>> the patch, kernel crash is triggered. With this patch applied, the error
>> or warning is dropped silently. We either check memslot->dirty_bitmap
>> in mark_page_dirty_in_slot(), or check it in kvm_arch_allow_write_without_running_vcpu().
>> I personally the later one. Let me post a formal patch on top of your
>> 'next' branch where the commit log will be improved accordingly.
> 
> As above, a full WARN is not a viable option unless ARM commits to rejecting
> KVM_DEV_ARM_ITS_SAVE_TABLES in this scenario.  IMO, either reject the ITS save
> or silently ignore the goof.  Adding a pr_warn_ratelimited() to alert the user
> that they shot themselves in the foot after the fact seems rather pointless if
> KVM could have prevented the self-inflicted wound in the first place.
> 
> [*] https://lore.kernel.org/all/Y20q3lq5oc2gAqr+@google.com
> 

Without a message printed by WARN, kernel crash or pr_warn_ratelimited(), it
will be hard for userspace to know what's going on, because the dirty bits
have been dropped silently. I think we still survive since we have WARN
message for other known cases where no running vcpu context exists.

So if I'm correct, what we need to do is to improve the commit message to
address Marc's concerns here? :)

Thanks,
Gavin


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
