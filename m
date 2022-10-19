Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2ABF28E8
	for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 12:19:02 +0000 (UTC)
Received: by mail-lf1-f45.google.com with SMTP id g1so27762125lfu.12
        for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 05:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l66+WLbhAlzPkyHFepjJ8VPyMoK+GDU3eUQBN3ZbwNk=;
        b=QfLHua9SUQ3cWtrSq3McnLndCx2mA3ijM5R/zZF0C4k3w7iTfpZiDMJD0dMzR8po7r
         nT12MX7BJ+z+zM1uhGOyUEMQ6LfI7wMqwDZLNgbyVWd6UEUjOINItZKgEiZqYiU27Iq5
         lK8khYGQGBm35jPdTcQndnZluivOIi36+9gQNysUPwL65LwDvnvOZUh75rXUwd6yMD6U
         /xnNP/G2B5RmZp1H3AN3TciuxupqJzz1XHKECOrL1Um2g/tA1R12KxRZihAwGMod7mBV
         vULmqNaidNLc0U27P3UnnAY+Ue5K9e24NPsWmtbT4Eyzlo5HcJQ2VjOBcWQavWyNmqH/
         AEhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l66+WLbhAlzPkyHFepjJ8VPyMoK+GDU3eUQBN3ZbwNk=;
        b=NrgP9HC2hRratKJMiP9Y12eVvvQ4aK9jap9ugdA0bpeBKWsQCgUK3AFkpCt6Sqb/jI
         ktHa0F8a8H3OlGUpcxMolKD9Vgv7FB/BueOSNn1rBTk52ffqvhK5sFYorzAH9ZLI5vt3
         nndt0pV3Ws2gJnzLOMDS9berXXA4BCFy8GeCAIx2vaY8en3OXIReoLG+E0z+GOqHDzFP
         HYArzmF6lm9YLd34i5h+0XHYQL5XSt2aFrKqT8RUMs8Qe41B25nFSRX250xmLSkDi/kD
         RxWomWQBtv4t+3bUM02Zic75v7TOuLlIq6CiLq3yBwkj0/kFrZlEeuDlsL4y17E+kUut
         QxPA==
X-Gm-Message-State: ACrzQf12ydNufZTGsO4T9JvYWnmyNSWXIAE+/ofZKiNqGscU4JUvTHBj
	gIElfQ0+BMFQMb6zMG5fqw/ozfBqSuq/dN+r5ap1vA==
X-Google-Smtp-Source: AMsMyM6QuAQGdziehqyNNg/dYLtJsZNxcgWER/SNrhmNQ9i6DMHJoP1Fx9le0dqEgW94QIKYhJ9aw9jygeYpRtlfJQw=
X-Received: by 2002:ac2:5ca9:0:b0:4a6:f2c:a1f9 with SMTP id
 e9-20020ac25ca9000000b004a60f2ca1f9mr217735lfq.26.1666181939680; Wed, 19 Oct
 2022 05:18:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221017115209.2099-1-will@kernel.org> <20221017115209.2099-13-will@kernel.org>
 <Y07YJvEsUnjSasA0@google.com>
In-Reply-To: <Y07YJvEsUnjSasA0@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 19 Oct 2022 13:18:23 +0100
Message-ID: <CA+EHjTyrBCjJ_=qEs1tQ_4SO+oMq4BTGTnipJa1kDRXVxu0RcA@mail.gmail.com>
Subject: Re: [PATCH v4 12/25] KVM: arm64: Add infrastructure to create and
 track pKVM instances at EL2
To: Quentin Perret <qperret@google.com>
Cc: Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, 
	Sean Christopherson <seanjc@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, kernel-team@android.com, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Hi,

On Tue, Oct 18, 2022 at 5:45 PM Quentin Perret <qperret@google.com> wrote:
>
> On Monday 17 Oct 2022 at 12:51:56 (+0100), Will Deacon wrote:
> > +static int find_free_vm_table_entry(struct kvm *host_kvm)
> > +{
> > +     int i, ret = -ENOMEM;
> > +
> > +     for (i = 0; i < KVM_MAX_PVMS; ++i) {
> > +             struct pkvm_hyp_vm *vm = vm_table[i];
> > +
> > +             if (!vm) {
> > +                     if (ret < 0)
> > +                             ret = i;
> > +                     continue;
> > +             }
> > +
> > +             if (unlikely(vm->host_kvm == host_kvm)) {
> > +                     ret = -EEXIST;
> > +                     break;
> > +             }
>
> That would be funny if the host passed the same struct twice, but do we
> care? If the host wants to shoot itself in the foot, it's not our
> problem I guess :) ? Also, we don't do the same check for vCPUs so ...

You're right, the host can shoot itself in the foot if it wants to.
The reason why we don't have it for vcpus is that that code was
factored out later, and as you said, a similar check isn't necessary.

TLDR: we'll remove it :)

Thanks,
/fuad
