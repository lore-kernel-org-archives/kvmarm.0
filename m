Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F40A6C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 11 Nov 2022 23:00:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AF484B7E8;
	Fri, 11 Nov 2022 18:00:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z+vG92+sK4R0; Fri, 11 Nov 2022 18:00:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 817834B7F8;
	Fri, 11 Nov 2022 18:00:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1D344B7E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2022 18:00:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1SIsURRsRLAb for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Nov 2022 18:00:17 -0500 (EST)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1F614B7DE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2022 18:00:16 -0500 (EST)
Received: by mail-pj1-f42.google.com with SMTP id
 b1-20020a17090a7ac100b00213fde52d49so5847917pjl.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2022 15:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=EXxysosi2pB1lHjcZe6TR6GN44puMGv7Sb4rfuvd3b8=;
 b=bOkMHaWMX8iYB/kv7bjVFPLxhSAgXvRcQzvvr0YMaufhZIiWvsZMZcpNSTN3jUaB1n
 +Z3wqSA0VeQ0pDal5g+FwtfY77ZNBrO9/cS6ob4mhSujxdETPi2+GYpWmWz8zjE9JVgF
 VQnp5EuqjWQP9mIrrXMpPC3YYMjaxKc6FM/2TVC2l1EDOIGZX0pvCBdRV81LIxT+Invc
 jDYfrm8JvweZAp1ipwPYCqC1XFNkwzcdYsYgxrr8+PzsFqOYTxfqiHht86Yv5fs5MBS9
 Q2MGl8ce9QLTQpnR72MeMr3Vwrx9QgnLZEmDZh37YMBxh+I9RvW8v1Lcpz3w6KnlmGIG
 mk5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=EXxysosi2pB1lHjcZe6TR6GN44puMGv7Sb4rfuvd3b8=;
 b=nNS6DJJ26vxA5hzhkVOtzzrWUDQ2XHOaIqGMlsYTWdmdIjzOelYiIsuiYZdml69pDO
 e4qDA63sKg3Gc6VlwgdXDuG3po8bIyrT1yn+LVXMyA0BjBeLBUTCNgKFy8gU2UIowyXd
 YdAP0SnY7hSNnz/tD11xElIieGuAghXKX+hKg8PnfGSz0l9N91UukBaYJSofCUCk79Vb
 cRzy10kFLgQmvSH1j5y1IVMVZ0uma8NDne6vfADlOgKthr4/azM9dkVoF8BIXxbVyz4M
 JQSBN6qS20yHyN1d/WZ09jrrh8KUikjq8spnRwhrPC+uJ8MnQUVaTmQ7q/L+O9WiDrAB
 6SLg==
X-Gm-Message-State: ANoB5pkAHAmepYtkdY5AlQ3PAnegx0gXgLB0aKbGBzUsxqNkVN+VmfAl
 WksbNk07M24cVhqKDbzI9UvQgA==
X-Google-Smtp-Source: AA0mqf6rHbHOxSOsy5zgUU8q0v9Y6gE7Cr/fm1KW8Ltanni/hVq24i1abbayy3TtoD+n1xu+b7dmXw==
X-Received: by 2002:a17:902:7896:b0:186:f256:91cd with SMTP id
 q22-20020a170902789600b00186f25691cdmr4405929pll.152.1668207615644; 
 Fri, 11 Nov 2022 15:00:15 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 t8-20020a63b248000000b00439d071c110sm1821495pgo.43.2022.11.11.15.00.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 11 Nov 2022 15:00:15 -0800 (PST)
Date: Fri, 11 Nov 2022 23:00:11 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v10 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y27T+1Y8w0U6j63k@google.com>
References: <20221110104914.31280-1-gshan@redhat.com>
 <20221110104914.31280-4-gshan@redhat.com>
 <Y20q3lq5oc2gAqr+@google.com>
 <1cfa0286-9a42-edd9-beab-02f95fc440ad@redhat.com>
 <86h6z5plhz.wl-maz@kernel.org>
 <d11043b5-ff65-0461-146e-6353cf66f737@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d11043b5-ff65-0461-146e-6353cf66f737@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, bgardon@google.com,
 andrew.jones@linux.dev, dmatlack@google.com, will@kernel.org,
 shan.gavin@gmail.com, catalin.marinas@arm.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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

On Sat, Nov 12, 2022, Gavin Shan wrote:
> Hi Marc,
> 
> On 11/11/22 11:19 PM, Marc Zyngier wrote:
> > On Thu, 10 Nov 2022 23:47:41 +0000,
> > Gavin Shan <gshan@redhat.com> wrote:
> > But that I don't get. Or rather, I don't get the commit message that
> > matches this hunk. Do we want to catch the case where all of the
> > following are true:
> > 
> > - we don't have a vcpu,
> > - we're allowed to log non-vcpu dirtying
> > - we *only* have the ring?

As written, no, because the resulting WARN will be user-triggerable.  As mentioned
earlier in the thread[*], if ARM rejects KVM_DEV_ARM_ITS_SAVE_TABLES when dirty
logging is enabled with a bitmap, then this code can WARN.

> > If so, can we please capture that in the commit message?
> > 
> 
> Nice catch! This particular case needs to be warned explicitly. Without
> the patch, kernel crash is triggered. With this patch applied, the error
> or warning is dropped silently. We either check memslot->dirty_bitmap
> in mark_page_dirty_in_slot(), or check it in kvm_arch_allow_write_without_running_vcpu().
> I personally the later one. Let me post a formal patch on top of your
> 'next' branch where the commit log will be improved accordingly.

As above, a full WARN is not a viable option unless ARM commits to rejecting
KVM_DEV_ARM_ITS_SAVE_TABLES in this scenario.  IMO, either reject the ITS save
or silently ignore the goof.  Adding a pr_warn_ratelimited() to alert the user
that they shot themselves in the foot after the fact seems rather pointless if 
KVM could have prevented the self-inflicted wound in the first place.

[*] https://lore.kernel.org/all/Y20q3lq5oc2gAqr+@google.com
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
