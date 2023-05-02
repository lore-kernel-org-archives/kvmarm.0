Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26EF33E9
	for <kvmarm@lists.linux.dev>; Tue,  2 May 2023 17:18:18 +0000 (UTC)
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-3f18dacd392so25525655e9.0
        for <kvmarm@lists.linux.dev>; Tue, 02 May 2023 10:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683047897; x=1685639897;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UC4a8f6Gne9pM4hFXpNmDoLhQCLeKV3rAUXB78ueUnI=;
        b=uiELwNIBB9aR1aczpkjeXKkVoU2sLftqcWZlOdh5bi3PsoclPZ+ARRrJEbVKVVYuBh
         JCs47I70fqOk3pqKhSLL2RDkCD5933AHaLa6R0r/E0Bgn3mq8YuUVdX08CXNf7Vk6H8T
         WyIprujAXbYHjFtDDUV8Z7bQQ+xRB67Y+3/f7T1LDvghhbovyzufVkCyYzCEfywzCBU7
         TfP2WIioZQjlDyzk1ry9mc+IldDP5CH0OCMzdKR4ndbdzmbc0kKK+Ie/FzO3W1VfJSkO
         TKHMkrY7B769c1/QGNBIYe71toXQSQHCzEGsqLISVargDPsmEFfpI6qSKf4jO2YP4uLF
         RyDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683047897; x=1685639897;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UC4a8f6Gne9pM4hFXpNmDoLhQCLeKV3rAUXB78ueUnI=;
        b=i4xv5E6+MChGFMheOZ82OgDMGbWdXDmWjXcNDoM43jvX0dIiH7sfvph/bmjQY98DQv
         A8KdOWpa5sm56BDY38jVKurB78TXc0Wog7S9RkZLP08hyDvKZsREZSEyGrN2+Rc95Klm
         oxnTyoQ9Gwg2PDLPGgAIPiTPOFi5T5qTiYA4gQYx5fCWLP5wm3Xh+Xj3J3iZQjUHWbMo
         FTElasIMb0ayEf0KIAk9wwg2Hvy9qSGu2mB8aO711l0BGvLSjTr67VnC/8LpUKBXymnD
         3/19cLSI/20+vUMp2vj9UgEjO/QrOwvmcVkJcU9UdcCW4jiRFe08cd44MRVe00dZ6B2X
         EGVw==
X-Gm-Message-State: AC+VfDxGhwvJmJJ48iKoJvqyuhZabJiDq6cp+rO+MSZt4jj2EcrFJAWT
	7u2KcneM/OZQjKE7Q84ys16u4arLqlZLzwXrM2p0rw==
X-Google-Smtp-Source: ACHHUZ6iyEsL7ZSIW0wVeXdbh79sKok0v4A3gQDG0iCZ6EAs2k7GXApQ4djHsSyVEvFt9ZPZRbTQYFvosV1Su6fKRME=
X-Received: by 2002:a1c:f203:0:b0:3f1:72dc:8bae with SMTP id
 s3-20020a1cf203000000b003f172dc8baemr12412266wmc.21.1683047897016; Tue, 02
 May 2023 10:18:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-5-amoorthy@google.com>
In-Reply-To: <20230412213510.1220557-5-amoorthy@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Tue, 2 May 2023 10:17:40 -0700
Message-ID: <CAF7b7mqq3UMeO3M-Fy8SqyL=mjxY4-TyA_PjgGsdVWZrsU2LLQ@mail.gmail.com>
Subject: Re: [PATCH v3 04/22] KVM: x86: Set vCPU exit reason to
 KVM_EXIT_UNKNOWN at the start of KVM_RUN
To: pbonzini@redhat.com, maz@kernel.org
Cc: oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com, 
	bgardon@google.com, dmatlack@google.com, ricarkol@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

During some testing yesterday I realized that this patch actually
breaks the self test, causing an error which the later self test
changes cover up.

Running "./demand_paging_test -b 512M -u MINOR -s shmem -v 1" from
kvm/next (b3c98052d469) with just this patch applies gives the
following output

> # ./demand_paging_test -b 512M -u MINOR -s shmem -v 1
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> guest physical test memory: [0x7fcdfffe000, 0x7fcffffe000)
> Finished creating vCPUs and starting uffd threads
> Started all vCPUs
> ==== Test Assertion Failure ====
>  demand_paging_test.c:50: false
>  pid=13293 tid=13297 errno=4 - Interrupted system call
>  // Some stack trace stuff
>  Invalid guest sync status: exit_reason=UNKNOWN, ucall=0

The problem is the get_ucall() part of the following block in the self
test's vcpu_worker()

> ret = _vcpu_run(vcpu);
> TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
> if (get_ucall(vcpu, NULL) != UCALL_SYNC) {
>    TEST_ASSERT(false,
>                               "Invalid guest sync status: exit_reason=%s\n",
>                               exit_reason_str(run->exit_reason));
> }

I took a look and, while get_ucall() does depend on the value of
exit_reason, the error's root cause isn't clear to me yet.

Moving the "exit_reason = kvm_exit_unknown" line to later in the
function, right above the vcpu_run() call "fixes" the problem. I've
done that for now and will bisect later to investigate: if anyone
has any clues please let me know.
