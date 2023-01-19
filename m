Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9206F196
	for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 18:38:29 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id p15so84840ybu.7
        for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 10:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ug88fDNkyBI0BBO5NHntR5hEaqs+0c3VcEsiCYtu59I=;
        b=CD5UjpNAve5p2n34E505LpPA+Fv/mil+a7ySZCwa4cdirZCLCoBP7rDvLCQsu3xmaB
         Ew7kYB69mBAEO/u7k+sGlpBjnG1dp4IffmBZLuYU10krSiyCe6kHbJFvifaS/8czl96m
         rAv2FcZ5hIDB/+YDXs6PskZm3OcerKWQHclqeSHcXaQu7YChMjVbglQbqgPg4lFmGaxM
         feHHgPhsOQIooQ/G/3kR94YjL8y0XRIA66qH9V9zeksKjA4S3ZxleHZ4g0UZsZMDpCZ7
         VeURifs8UuavreMHSVgeZo4LBtIrsFjf78bsFmqLArlOR5YfXrO5d9p3C+p8ot5Of0Bv
         LFUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ug88fDNkyBI0BBO5NHntR5hEaqs+0c3VcEsiCYtu59I=;
        b=YpbipOQsGpmpCAwbcDr6htMNXqV74K8AStqmX87zVBK1Qbg6Eq5I8ju3SKM7nvqLgc
         dSP882pKX+Vuza19V4++AeyrajpfJ5Ype6RId51K6n1VCnKnFWa5sW8EirSIK5e1fdCp
         UOGn86LjIo6fNslNQzGl180uTifqnbdUJBAAbrM7ys5MW6VqP+oaXLf9XazexQ9lQR92
         aXD8dZRgcErZF5YDDEn5KSi0ndMseeOHTSamtZ6t7ybR0IF3HiUGQBHGpO5lWr1BKBtR
         BavtNNFs1UEvBLWN/rK+k+NF2+wNmDXJye2Gk0+/pDmAHn2qPFcmWQ29B8KyDpNP6M6l
         OFCA==
X-Gm-Message-State: AFqh2krfZFoMfbxqe8bg7IAuSvGpiLLJY+cMbhj61HWxarvyJeT9kZDP
	yc/GsvrqqncVf95UTSawHMqWPpUACarQhujJd4921w==
X-Google-Smtp-Source: AMrXdXvj7JLSu67yZSCrAXbJnFAdEysNvlQhdZNSBcAvK1s7UO8zpqZUtwsbUaHqW+fn/EaUvPQ8kleXCyZxAjw4CDE=
X-Received: by 2002:a25:d4e:0:b0:800:9451:c106 with SMTP id
 75-20020a250d4e000000b008009451c106mr14043ybn.191.1674153508397; Thu, 19 Jan
 2023 10:38:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <Y8l6egh2wWN7BUlZ@google.com>
 <86tu0mmo8m.wl-maz@kernel.org>
In-Reply-To: <86tu0mmo8m.wl-maz@kernel.org>
From: David Matlack <dmatlack@google.com>
Date: Thu, 19 Jan 2023 10:38:01 -0800
Message-ID: <CALzav=dya7GsOD7-dm3649Xe4Xo_p5gJACvjZHtpbk0QwoU-gg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/37] KVM: Refactor the KVM/x86 TDP MMU into common code
To: Marc Zyngier <maz@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Nadav Amit <namit@vmware.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Yu Zhao <yuzhao@google.com>, Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>, 
	Ben Gardon <bgardon@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Krish Sadhukhan <krish.sadhukhan@oracle.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 19, 2023 at 9:24 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 19 Jan 2023 17:14:34 +0000, David Matlack <dmatlack@google.com> wrote:
> > I'd like to target RISC-V first, since it has significantly lower risk
> > and complexity than e.g. ARM (which has pKVM, stage-1 walkers, and
> > [soon] nested virtualization to deal with).
>
> And (joy, happiness), the upcoming 128bit page table support[1].

Oh good, I was worried the ARM port was going to be too easy :)
