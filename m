Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF883217
	for <kvmarm@lists.linux.dev>; Mon, 10 Apr 2023 18:22:58 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1a652700c36so13415ad.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Apr 2023 11:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681150978; x=1683742978;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eVM18TxEI3qmFS0lIFJvyIgGduj2m2mbGl7Gx7uGIpc=;
        b=ZD+Xwl+epT0fVlytabKQ37TXfAq0mFRzxOndOEnT1EU0v1LH6cW6MWgZ8ZQRt3EBng
         BI3QthRVFU9NX5VlT+Fl3PVGZ5z0s3EYs/h9kX0ZszEeaDaCpC4d1bb+bsbFAGeSG7EY
         SB9jXeQxsg3D4AwN7OzRIdxCNMMif5g8eUXWyd6uUzBuXczYDuVFnqRrh5n8FTHvwBNe
         M5SXab8R2Ajup6rtXA2QaK7dGfweG50PWnSD+FmD6W3d/xME5gWjizwLuhqSPrtCeU2R
         jJcTYJCpkt6iPseT3sq5V23arEte5y1h9mqbwvTzUpaFUHi8xT+e/NOLAK/xhdVVOR9W
         6bKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681150978; x=1683742978;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eVM18TxEI3qmFS0lIFJvyIgGduj2m2mbGl7Gx7uGIpc=;
        b=EBzDfqwcOsQxF2VO6n9NFwdbV/fOLbEi+l0hNbTMGwXhy2oJJNMOSB8LxEe3+JZniy
         NCSX/BPXYvcyzHS82heI6NwnvJL4RW5yEcrpCxy3Q7ea29Twi4G9XqCxB8/idKOJU2EH
         t2IRZphXWh7STQa3eQ4ZZFazxX30JaM6YuOwYhsNXLWf9MNY9SOada9GUp00CW7b8Yyz
         L3wyIy1MaX3yT//hx/UlJzYXcyG8BeZnh+TQ26nkPajexEJWB9pxuiVZyijBmofHn2JS
         wdjPfXZjDND5L2B2X/YNT6pcIkPE8KqCRwqay3HsIgsLivjqqSzsAO7nhM2KsVbKvqHL
         X/+g==
X-Gm-Message-State: AAQBX9c+DkP/FVUgMj53EcLSdk17lFY8uj/zvYwK3LMCJmryS1GgXDr0
	09lhlGIefywtRZZacZhdRTN5HQ==
X-Google-Smtp-Source: AKy350b0R1/oKXYKBc1KSktZFe2bjEvW3LPVpRtJqCgm/kjwmuBME9tMz2jM1GpEWLtBZwaj+F117Q==
X-Received: by 2002:a17:902:a515:b0:19f:3c83:e9fe with SMTP id s21-20020a170902a51500b0019f3c83e9femr29573plq.14.1681150978140;
        Mon, 10 Apr 2023 11:22:58 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id x27-20020a63171b000000b0050f74d435e6sm7091793pgl.18.2023.04.10.11.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 11:22:57 -0700 (PDT)
Date: Mon, 10 Apr 2023 11:22:54 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: pbonzini@redhat.com, oupton@google.com, yuzenghui@huawei.com,
	dmatlack@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	qperret@google.com, catalin.marinas@arm.com, andrew.jones@linux.dev,
	seanjc@google.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com,
	eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
	rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Subject: Re: [PATCH v6 12/12] KVM: arm64: Use local TLBI on permission
 relaxation
Message-ID: <ZDRT/qAnbf9Rp+1M@google.com>
References: <20230307034555.39733-1-ricarkol@google.com>
 <20230307034555.39733-13-ricarkol@google.com>
 <87356a5ckf.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87356a5ckf.wl-maz@kernel.org>

On Sun, Mar 12, 2023 at 01:22:40PM +0000, Marc Zyngier wrote:
> On Tue, 07 Mar 2023 03:45:55 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > From: Marc Zyngier <maz@kernel.org>
> 
> Thanks for writing a commit message for my hacks!
> 
> > 
> > Broadcasted TLB invalidations (TLBI) are usually less performant than
> 
> More precisely, TLBIs targeting the Inner Shareable domain. Also,
> 's/broadcasted/broadcast/', as this is an adjective and not a verb
> indicative of the past tense..
> 
> > their local variant. In particular, we observed some implementations
> 
> non-shareable rather than local. 'Local' has all sort of odd
> implementation specific meanings (local to *what* is the usual
> question that follows...).
> 
> > that take millliseconds to complete parallel broadcasted TLBIs.
> > 
> > It's safe to use local, non-shareable, TLBIs when relaxing permissions
> 
> s/local//
> 
> > on a PTE in the KVM case for a couple of reasons. First, according to
> > the ARM Arm (DDI 0487H.a D5-4913), permission relaxation does not need
> > break-before-make.
> 
> This requires some more details, and references to the latest revision
> of the ARM ARM (0487I.a). In that particular revision, the relevant
> information is contained in D8.13.1 "Using break-before-make when
> updating translation table entries", and more importantly in the rule
> R_WHZWS, which states that only a change of output address or block
> size require a BBM.
> 
> > Second, the VTTBR_EL2.CnP==0 case, where each PE
> > has its own TLB entry for the same page, is tolerated correctly by KVM
> > when doing permission relaxation. Not having changes broadcasted to
> > all PEs is correct for this case, as it's safe to have other PEs fault
> > on permission on the same page.
> 
> I'm not sure mentioning CnP is relevant here. If CnP==1, the TLBI will
> nuke the TLB visible by the sibling PE, but not any other. So this is
> always a partial TLB invalidation, irrespective of CnP.
> 
> Thanks,
> 
> 	M.
> 

Thanks Marc. Sent a new version incorporating all the above.

Thanks,
Ricardo

> -- 
> Without deviation from the norm, progress is not possible.
