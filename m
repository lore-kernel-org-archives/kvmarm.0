Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C220C43334
	for <kvmarm@archiver.kernel.org>; Sat, 25 Jun 2022 08:53:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 148B849F3B;
	Sat, 25 Jun 2022 04:53:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QE3I1paQA29I; Sat, 25 Jun 2022 04:53:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 790944B21C;
	Sat, 25 Jun 2022 04:53:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1903249F0C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 19:50:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mnUMiK4n1vwr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jun 2022 19:50:53 -0400 (EDT)
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com
 [209.85.210.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F0E7D41175
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 19:50:52 -0400 (EDT)
Received: by mail-pf1-f182.google.com with SMTP id n12so1100282pfq.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 16:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=zbb8jnyf9qPdBsIbRpO/u6Nva8QOxFa0c+HbQiJfy+k=;
 b=IlG62ZJ+WehrUE0/WvoRAjWTwprtTh9sQ65qKKaJJDTzehtixHvUSG/LPmWh2YzpYy
 oMZ4vl1RfjMmr6Eq0pa1hPVoBNsux4hFJQxZuwMwTYY0m76RkNFzBg88Ff/LjT+i+SNn
 exnmCJwxY/Xd6voz5p06GCvpDOyehFDT/2EWnfxu0ilHQXKwQvB0mc1fW4wfiHHu5GYd
 nMGHgybQzJUY8rbRkmKPCJsxlWgO1dqQl0b5Bz9vl9tnMa3/ZYHfjECinYtydaGFEOz+
 j9LnXH9oA8MFoIwboFlDlvhH+Hyd/Bk0lggkqo/gv78dOEbORhDCnmrq6N0aR0my7hID
 psGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=zbb8jnyf9qPdBsIbRpO/u6Nva8QOxFa0c+HbQiJfy+k=;
 b=nYY7sdL2q9YpPE6l9V5jEMQ0NLmAmQYpUSRrcvyTki431YhY+RgsNdpLDhfyWbSUjW
 03Zi81w8psGDJVV86L7C3icEdCiPuRzQBnXgBcknRw9DLKN9IOx7wXuFTZWhfTAG83kY
 Q7hIcXZSM6OLmBkdvvFPCdNgzCiVipQt02xmM5iUIGwV+PbUNCzVF4g8cvP+sURwXwoO
 J3xFOOrpugcTV2NBpG+XN/GyUUDCdYqFm2KhhMIJ8RbAsWEqG2qiI2AL4zOGVWhkJnjC
 RymHGHkOZwcB1VZOkiLX4dr5IOKianU5bUynjw42wf090MgToZLcfWbkWUVkZGokFLxo
 YAJQ==
X-Gm-Message-State: AJIora//45IqtKmY3iOh4+kP70ZkF/lc65FWdqHU0ycsvcoZsRPLVa6G
 b8vcsMC/++jefaEgw3Gzqh3zOg==
X-Google-Smtp-Source: AGRyM1sVe+SHQIuJJYmlyoK1SLTo1HgUkXEAbRufb8AZnkgcLimW/kT6zmNvpPgOUmD9v4ZPCT3mBg==
X-Received: by 2002:a05:6a00:1a4a:b0:518:bbd5:3c1d with SMTP id
 h10-20020a056a001a4a00b00518bbd53c1dmr43028461pfv.64.1656028251848; 
 Thu, 23 Jun 2022 16:50:51 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com.
 [34.125.103.223]) by smtp.gmail.com with ESMTPSA id
 bd10-20020a656e0a000000b0040d3613d9dcsm194912pgb.34.2022.06.23.16.50.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 23 Jun 2022 16:50:50 -0700 (PDT)
Date: Thu, 23 Jun 2022 23:50:45 +0000
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 00/23] KVM: Extend Eager Page Splitting to the shadow
 MMU
Message-ID: <YrT8Vcr2sXcm3NPB@google.com>
References: <20220622192710.2547152-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220622192710.2547152-1-pbonzini@redhat.com>
X-Mailman-Approved-At: Sat, 25 Jun 2022 04:53:35 -0400
Cc: kvm@vger.kernel.org, maz@kernel.org, jiangshanlai@gmail.com,
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, bgardon@google.com, maciej.szmigiero@oracle.com,
 kvmarm@lists.cs.columbia.edu, pfeiner@google.com
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

On Wed, Jun 22, 2022 at 03:26:47PM -0400, Paolo Bonzini wrote:
> For the description of the "why" of this patch, I'll just direct you to
> David's excellent cover letter from v6, which can be found at
> https://lore.kernel.org/r/20220516232138.1783324-1-dmatlack@google.com.
> 
> This version mostly does the following:
> 
> - apply the feedback from Sean and other reviewers, which is mostly
>   aesthetic
> 
> - replace the refactoring of drop_large_spte()/__drop_large_spte()
>   with my own version.  The insight there is that drop_large_spte()
>   is always followed by {,__}link_shadow_page(), so the call is
>   moved there
> 
> - split the TLB flush optimization into a separate patch, mostly
>   to perform the previous refactoring independent of the optional
>   TLB flush
> 
> - rename a few functions from *nested_mmu* to *shadow_mmu*
> 

Thanks for the v7 Paolo!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
