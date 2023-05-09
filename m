Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338581991F
	for <kvmarm@lists.linux.dev>; Tue,  9 May 2023 22:19:18 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1ab1b79d3a7so44688535ad.3
        for <kvmarm@lists.linux.dev>; Tue, 09 May 2023 15:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683670757; x=1686262757;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=97P6niZFRFf/HHS0XuApR4Gw+Av8dWivDdLORSGJDP8=;
        b=NZybfF9HDUsyXWRC364byOFxu3f1tWyKsUz7+55Ad4nKku3jTfcJa4iyE+fuEythcB
         pfezWVcHdJa3T/6s7ogqfTthNnvEp83C6JAmO0qIm000LLVF0/VOUfWLVAojHU69Vo6r
         YKB6Wg3h+hoA3Kcb9ikkHjkPxXN+cfGyQPupMN2tgcM8se+HHscpnRBxeU+KGe9tytfg
         7DHAaItb2ckU+H8e+xAl1koXhopo8nc7TB069/+2EPsdAeAO6MmAS9mkZX4260EHDzjZ
         pMRvzh+64NMoWGla/JNs4wSLrglp+59SKTmqFwvwWZZFXthf/vqQKo5k8Y5uubdkyVQF
         k29Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683670757; x=1686262757;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=97P6niZFRFf/HHS0XuApR4Gw+Av8dWivDdLORSGJDP8=;
        b=YJ1C+SGLMdThGudB2hdKZoCUmc9NOVrpLBEFIo/h7guK7D4bqwQtvhr8rAMoo9J+ss
         y42NytsOJ1wJ3S/b5hk/uvMc8G8m703+GwKy8oE9nSEk4+3Rw5mzjp4RNi9kjihcVxOj
         WT2I5yBT5VSWB+WoQgOKhWHNcM9DNvpkYMYQ+VdFNuscppZuO+NLWzUBln5YxGwglSA+
         WSBfX29gV9yaRRxoE6puSp+fqxgaGMIlbhCfOR7yPeWu9TMRlvCViowt9nhJYy+dxzFP
         8JkERPmSqRVR/l/6WNVPQ12N7TCTkLa4jkI0cWdq8pJBG6629tGBWdhUHpRNsv5PL1vw
         cL3w==
X-Gm-Message-State: AC+VfDx3vdXwlxpDmrWkAUakXUpHT3wPg8gryHfWaYKnDUx9Kx5nbEfE
	GE2uiJqmenA0OtG3rycpzBNz6Q==
X-Google-Smtp-Source: ACHHUZ5GEq8I42wC+TGBklQvlCmhdNY72eJQYazx+WQ9pYBR0rfPTY6Y2qD4UQemt+kSm5ksJqYc4w==
X-Received: by 2002:a17:902:da90:b0:1a2:2091:eeae with SMTP id j16-20020a170902da9000b001a22091eeaemr19021363plx.40.1683670757461;
        Tue, 09 May 2023 15:19:17 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id j5-20020a170902c3c500b001a6ff7bd4d9sm2153872plj.15.2023.05.09.15.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 15:19:16 -0700 (PDT)
Date: Tue, 9 May 2023 15:19:12 -0700
From: David Matlack <dmatlack@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
	seanjc@google.com, jthoughton@google.com, bgardon@google.com,
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZFrG4KSacT/K9+k5@google.com>
References: <20230412213510.1220557-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>

On Wed, Apr 12, 2023 at 09:34:48PM +0000, Anish Moorthy wrote:
> Upon receiving an annotated EFAULT, userspace may take appropriate
> action to resolve the failed access. For instance, this might involve a
> UFFDIO_CONTINUE or MADV_POPULATE_WRITE in the context of uffd-based live
> migration postcopy.

As implemented, I think it will be prohibitively expensive if not
impossible for userspace to determine why KVM is returning EFAULT when
KVM_CAP_ABSENT_MAPPING_FAULT is enabled, which means userspace can't
decide the correct action to take (try to resolve or bail).

Consider the direct_map() case in patch in PATCH 15. The only way to hit
that condition is a logic bug in KVM or data corruption. There isn't
really anything userspace can do to handle this situation, and it has no
way to distinguish that from faults to due absent mappings.

We could end up hitting cases where userspace loops forever doing
KVM_RUN, EFAULT, UFFDIO_CONTINUE/MADV_POPULATE_WRITE, KVM_RUN, EFAULT...

Maybe we should just change direct_map() to use KVM_BUG() and return
something other than EFAULT. But the general problem still exists and
even if we have confidence in all the current EFAULT sites, we don't have
much protection against someone adding an EFAULT in the future that
userspace can't handle.
