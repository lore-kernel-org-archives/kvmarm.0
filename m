Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F32BD303
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 23:28:43 +0000 (UTC)
Received: by mail-ua1-f53.google.com with SMTP id 30so47794uab.8
        for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 15:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bOUeJWFvpV4H+dOD0lIXGUYEiNv7vk7Mm3Pftn0hOdg=;
        b=ATNbHY/qOA/meyaYYhpYIn1c4h/RWyY7gYBaWNy/tTa/ed5lkLfPs7+yiWtH/7qIwm
         evUezWZKGO3MDQn/BNax7w4mY21YV0DklYie8AUIAGWDdkaoYaRYGaxq+ogzuKyf3Gk8
         NPLO4Cmf1G8B+yn2Jxf2h61RKscdjhJqXc1w/hWpIKsaiRmMTiUmXD6gwlejrK6YnIew
         NNELUQ70eXbpSm8F5XWU4Yf+DOoAXUtiJINe0Beg9G3NeV7g1BD06PEGpCtMeK90zPrJ
         BHyXEDINnikEkWmBjdDM9oSfVb77KMdvcy/AtPFlcytAW0BsOO4H57ZZqEopRF5WiW1u
         3igw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bOUeJWFvpV4H+dOD0lIXGUYEiNv7vk7Mm3Pftn0hOdg=;
        b=lAJuiKXQSrjVjLHNlXtCpxwkX1sp49xhFQ+IkVSJt20Canhibilf8gNYdukdbZS+/l
         DxeBp3ic/+KqUX4QPJ6HBRZfjBCjD8+sgvewo8dO0FSBlsTgQ+SdowD5APMnEkkNiTXw
         ZHN+P6DOlB/bwEnwfk9mYCRZXK+uBU04grbgqOUOfJPOjoeoeT5jfihqzhyUycNzSsOA
         OlArUCMmrd9nu/YyIMaD74CPSWh6KweU4onQQajifSVzAing2B1jdnrAsgpGkpj06+8X
         8wlzWLbX7nRbNuka+4T+ls5iVDcqDnLK+pPJKmy1IihYyr+03eMj3Wjx9eiU8KbK+2Ac
         qfVQ==
X-Gm-Message-State: AO0yUKWvoSajKidh3EVq+WjyYLwEXaDPe8YgS2pcNDO/ZpJUQlZh6Y+i
	xs9uTsrroA7nmMgnyaZSFqIaun+S3ktDAcYweI8VbQ==
X-Google-Smtp-Source: AK7set+petihwvjYEiAR/DINUP0S0MHgbGcQm4dM6CcqoPFChMgAb2nx4jmTrPOuzi3uyIEbQoNc3lKvZSD3XBz3PSU=
X-Received: by 2002:ab0:3b56:0:b0:68a:866c:a09b with SMTP id
 o22-20020ab03b56000000b0068a866ca09bmr395108uaw.73.1676503722356; Wed, 15 Feb
 2023 15:28:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-8-amoorthy@google.com>
 <Y+0jcC/Em/cnYe9t@linux.dev>
In-Reply-To: <Y+0jcC/Em/cnYe9t@linux.dev>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 15 Feb 2023 15:28:31 -0800
Message-ID: <CAF7b7mpbAdQtvXCQCk5kLrSn0bN=fLYVzEWXVW34OgBSxzHA_g@mail.gmail.com>
Subject: Re: [PATCH 7/8] kvm/arm64: Implement KVM_CAP_MEM_FAULT_NOWAIT for arm64
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>, 
	Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 15, 2023 at 10:24 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> All of Sean's suggestions about writing a change description apply here
> too.

Ack

> > +     if (mem_fault_nowait && pfn == KVM_PFN_ERR_FAULT) {
> > +             vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
> > +             vcpu->run->memory_fault.gpa = gfn << PAGE_SHIFT;
> > +             vcpu->run->memory_fault.size = vma_pagesize;
> > +             return -EFAULT;
>
> We really don't want to get out to userspace with EFAULT. Instead, we
> should get out to userspace with 0 as the return code to indicate a
> 'normal' / expected exit.
>
> That will require a bit of redefinition on user_mem_abort()'s return
> values:
>
>  - < 0, return to userspace with an error
>  - 0, return to userspace for a 'normal' exit
>  - 1, resume the guest

Ok, easy enough: do you want that patch sent separately or as part
of the next version of this series?
