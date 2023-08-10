Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F0C20CA8
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 19:55:29 +0000 (UTC)
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-48720a45517so377260e0c.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 12:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691697328; x=1692302128;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IeUEtLNCBueCk26TVmOxk+FIioqZ1Dj8pH3cliM6DxE=;
        b=epXnByH/8ejipWZo8Gb7nTwQIot/GhIq6Zi2XbtAvEHRT6rzd+Q4jHSQQlTWXHb60q
         gINIrabf/GTYSoBPy7c8i78Gm4BQXVkL/r+FwVxDoiwJVWGMhae1csh/tMVn/FLI8t3E
         pqf3PmRBAKug7p5h4e8EvQr3Fvg1Pi53FaCseprgn9yGsuZ1cb19UZr9qnXVPjxalbhM
         YylmeAyUGBv4v/fog83TCEF35F3sWOvujH7w5YJaHv2Rn933ExBzzOl/vytWguFn0x1D
         abL6pmAHQGmUyN774L9fxm5hEdGGbVC/XHiOsYPALFJl5524UTxSnrKU8nDAz9/5ddGb
         MkBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691697328; x=1692302128;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IeUEtLNCBueCk26TVmOxk+FIioqZ1Dj8pH3cliM6DxE=;
        b=QEaE/FmMePKS7m4J6w7O9AYYca2RefG+bzBuGF/BC6yYuxjENDtWXQWrCxc/3jgthr
         o8wSCsvGmEMxCgkX058i/SLGt4W1+BjOG/G1JwWLT2OILeFw17o8NKkRhJ60CStBzOaz
         8l2emZvWFVWpSy96dRHcpWuT2kpG9FgppyWOXJiLPPGGKGRkn87VWncoTgeyKugn9Iqq
         sKiRx0J7xac2ui2P14xKxRFvq86Fnfy2V/EEC88IWHaYnHQmgIomtdiJATsbloh0jaEc
         4wVxfWT5htTxqWtXTzYgflleIiiSIu0Pq/dnLA3dfiI7RtDngfUzJ+uvKdn5jpyFO81M
         N7KA==
X-Gm-Message-State: AOJu0YwLpH7f/tF+psqX+/jezE4oJakWhnHi23BBEymkV4gG5FcOaeZn
	ZYar5twqARtvyKCFRetxYabtrUrDdXRhcdfGPOydQg==
X-Google-Smtp-Source: AGHT+IEWUaoxig8eLTa1Ao/y0Xm6kZQA+s+ujJtuQUpZdS0k/HgqODK8DhNBiVCDevZu+xAsNk7PNr0fqO0zVQv77iY=
X-Received: by 2002:a1f:6011:0:b0:45e:892b:d436 with SMTP id
 u17-20020a1f6011000000b0045e892bd436mr2462082vkb.12.1691697328020; Thu, 10
 Aug 2023 12:55:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-2-amoorthy@google.com>
 <ZInRNigDyzeuf79e@google.com> <CAF7b7moOw5irHbZmjj=40H3wJ0uWK5qRhQXpxAk3k4MBg3cH3Q@mail.gmail.com>
In-Reply-To: <CAF7b7moOw5irHbZmjj=40H3wJ0uWK5qRhQXpxAk3k4MBg3cH3Q@mail.gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 10 Aug 2023 12:54:51 -0700
Message-ID: <CAF7b7mqczaqwFhFaoicOtWHGEf50f-14cuCXSPj36eZsuCoGUg@mail.gmail.com>
Subject: Re: [PATCH v4 01/16] KVM: Allow hva_pfn_fast() to resolve read-only faults.
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"

I figured I'd start double checking my documentation changes before
sending out the next version, since those have been a persistent
issue. So, here's what I've currently got for the commit message here

> hva_to_pfn_fast() currently just fails for read faults where
> establishing writable mappings is forbidden, which is unnecessary.
> Instead, try getting the page without passing FOLL_WRITE. This allows
> the aforementioned faults to (potentially) be resolved without falling
> back to slow GUP.
