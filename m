Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1E6C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 18 Mar 2022 20:34:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 434D140FD8;
	Fri, 18 Mar 2022 16:34:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t3o2a-66kvkG; Fri, 18 Mar 2022 16:33:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C42049E08;
	Fri, 18 Mar 2022 16:33:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7E3F41021
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 16:33:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xu8lO02fy--Q for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Mar 2022 16:33:56 -0400 (EDT)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4B4040FD8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 16:33:56 -0400 (EDT)
Received: by mail-pl1-f172.google.com with SMTP id w4so7882049ply.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 13:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=tFfFbJf1vAzHljyR7C3YDseHim9j7bwqTrFQGi3jIro=;
 b=Q1r4h8RaITr0aQCjF1QZKsJYT4DciEIrKNHByQIkdr5xZAtIQY9W+Iewcgbbvysj83
 Pdx0ShXzhwsSac/OGeXzsaTACCyvI4f0aZWp0ndP8zwjyApE0mtm2k2pXjr/dSvor7IN
 pxyKhMDdJaWrGRxh6gV0T28SBjAdC/L19iLJH6OR1i4ggzGkNLGFvi/+KBmyq6i6AXLw
 9bDABdk+9eJDqszmbZKq1lvlRMB5b3B0O8EUQGVoUBWnC5zSxCGin5Fzolm/Qrbw8iuJ
 R86Km71oE7uzBfxRM2tH9673s84i269FK9h+yP5hNsWnPp8323LwrCsInRpVWt1TOFg2
 WyJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=tFfFbJf1vAzHljyR7C3YDseHim9j7bwqTrFQGi3jIro=;
 b=Xyw4QHd4SqStUMeadV7PcaM06VtzW8wjn2CDGwT/cmq36oFI3fUobdDf1qtvM0V7iB
 U0oX837AaWmToYU/9IhtRkHlz2y0nH5O1WiOTHl/xvWnkuGntQGpHpJ3wSrne3jIk8+k
 fIBQyF6+YW/0TKyqDQoLUoP+0RQDUnA4gPaUaWY1o122XwPatDMDToKdbl2OBVvnLn/r
 dPV1++mQx0+zCOmdS3IXq1a9wueqlQY6FwgCh1pedDZq6eTxBcDyPBfH59nLExIpKjvD
 7TCAssema6CRJ0NqS3MK0129n3vspOUP8DyreZtjOGnvhSR6VVD2yd6MRzrJn/xMo3Cx
 7LjQ==
X-Gm-Message-State: AOAM533iSYDEK1aRsPUIZgzdaZZHjx9b7B+A3PTZTodnLVLnaQYqJ3ju
 YEYZXZtqSUEy0RJwGKSdFgHetg==
X-Google-Smtp-Source: ABdhPJyheeKWO7KDs5dTxcfDqqgwhhv6TVeXcbIYcFgjfaoP5aRQlihVxPCV2xg2xLTxORXmiGB4TQ==
X-Received: by 2002:a17:902:f64d:b0:14f:fb63:f1a with SMTP id
 m13-20020a170902f64d00b0014ffb630f1amr1249332plg.159.1647635635754; 
 Fri, 18 Mar 2022 13:33:55 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 r1-20020a17090a560100b001bf72b5af97sm8810827pjf.13.2022.03.18.13.33.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 18 Mar 2022 13:33:55 -0700 (PDT)
Date: Fri, 18 Mar 2022 13:33:51 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 06/11] KVM: selftests: Add missing close and munmap in
 __vm_mem_region_delete
Message-ID: <YjTsr3zPilDvHIF1@google.com>
References: <20220311060207.2438667-1-ricarkol@google.com>
 <20220311060207.2438667-7-ricarkol@google.com>
 <CANgfPd9d=C65y=hbpcf5y68d=u+p0LTtk3OO+q8reGmjv8TEEg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANgfPd9d=C65y=hbpcf5y68d=u+p0LTtk3OO+q8reGmjv8TEEg@mail.gmail.com>
Cc: kvm <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>,
 kvmarm@lists.cs.columbia.edu
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

On Wed, Mar 16, 2022 at 12:09:44PM -0600, Ben Gardon wrote:
> On Fri, Mar 11, 2022 at 12:02 AM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Deleting a memslot (when freeing a VM) is not closing the backing fd,
> > nor it's unmapping the alias mapping. Fix by adding the missing close
> > and munmap.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index ae21564241c8..c25c79f97695 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -702,6 +702,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
> >         sparsebit_free(&region->unused_phy_pages);
> >         ret = munmap(region->mmap_start, region->mmap_size);
> >         TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
> > +       if (region->fd >= 0) {
> > +       /* There's an extra map if shared memory. */
> 
> Nit: indentation

Will fix in v2.

Thanks for the reviews!
> 
> > +               ret = munmap(region->mmap_alias, region->mmap_size);
> > +               TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
> > +               close(region->fd);
> > +       }
> >
> >         free(region);
> >  }
> > --
> > 2.35.1.723.g4982287a31-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
