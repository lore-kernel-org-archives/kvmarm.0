Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9927B
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 17:03:04 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id m11-20020a65564b000000b004fbec68e875so1400937pgs.1
        for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 09:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rXpHrm412Se84icLxlhp0c6gn6FcOiMTmYzMu9XFzE0=;
        b=aLJK/RN+Unz5AmXXe1jY38G4rjdZYbR+ulpZxlfYoinsVuT0AVhwUWxXtbsDj+cxdi
         o/xO1bFJomGKwqEdz2sz5QYTN8lW3dhyO/q0maVszkrPBtu9rJ2rfyW4uv1VIkOD7umC
         CR3YEAR8APgGj00V5yp/WQbwIpTihgXmTNa6SOOPf6hlfOikYJu/R38zHTK/27VSgPaf
         FfblQYJBNauILeThbiUEl6MpF57hSexikv3tHqsVOC3XjHRTwp+rphmcFQ6hh/GFzqIJ
         847rlbVckcQrssaXB7GwVsA8r2Ud6PaIUWUPJLPxXVfxrK9vAup92Yn4Rg1nkwG16Jof
         Bgyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rXpHrm412Se84icLxlhp0c6gn6FcOiMTmYzMu9XFzE0=;
        b=tA91RTyTKvabQoJ/Wymnaqloggkdv2NMZiDbu/XjDFxrF75hd/a8clTO6XRaVWQjG2
         RxH7PZHNJEgP059IWRvdP/VTBJa6eUS6r9lRDPlglyI/HdJqfdh3XQX3Xe7pskG3fple
         VcILj5H8RmolN948kGXnj9VlYeVpHe3OB4/AnnhRK1Pc8KVKYknL4WrXJUjPga8pjz7T
         c8DXyhOx3Q3H8wEyV+qEtZcC0OREsgmqjwlPlf1U3ZU3tyQbpVVvWEQTTkvY5CFqR+UI
         WgwrH96KCq7zgQtf/bHo6kGhzQpACpulxmFt0PRcV/Zmf5r9Y37ioflULLP12ArCyr3G
         XTdw==
X-Gm-Message-State: AO0yUKVUhTrbzcUCOCNWlfxkP2HBDbN/Ur95St5EZ1VtFzHZ8DALkh/+
	bTojog1LkC5Kih4aPBj5z6mXLWqF7Cc=
X-Google-Smtp-Source: AK7set/RArgkpEYAvlgEF0UvF1fVSH+rZwKn4nEsJtUurS58zRCLANNB+sRdpIYCCh6+5smbam+TI/Xym8o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:af59:0:b0:4fb:ee04:732a with SMTP id
 s25-20020a63af59000000b004fbee04732amr466823pgo.2.1676480583747; Wed, 15 Feb
 2023 09:03:03 -0800 (PST)
Date: Wed, 15 Feb 2023 09:03:02 -0800
In-Reply-To: <Y+yfhELf/TbsosO9@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-5-amoorthy@google.com>
 <Y+yfhELf/TbsosO9@linux.dev>
Message-ID: <Y+0QRsZ4yWyUdpnc@google.com>
Subject: Re: [PATCH 4/8] kvm: Allow hva_pfn_fast to resolve read-only faults.
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Anish Moorthy <amoorthy@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, James Houghton <jthoughton@google.com>, Ben Gardon <bgardon@google.com>, 
	David Matlack <dmatlack@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 15, 2023, Oliver Upton wrote:
> On Wed, Feb 15, 2023 at 01:16:10AM +0000, Anish Moorthy wrote:
> > The upcoming mem_fault_nowait commits will make it so that, when the
> > relevant cap is enabled, hva_to_pfn will return after calling
> > hva_to_pfn_fast without ever attempting to pin memory via
> > hva_to_pfn_slow.
> > 
> > hva_to_pfn_fast currently just fails for read-only faults. However,
> > there doesn't seem to be a reason that we can't just try pinning the
> > page without FOLL_WRITE instead of immediately falling back to slow-GUP.
> > This commit implements that behavior.

State what the patch does, avoid pronouns, and especially don't have "This commmit"
or "This patch" anywhere.  From Documentation/process/submitting-patches.rst:

  Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
  instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
  to do frotz", as if you are giving orders to the codebase to change
  its behaviour.

> > Suggested-by: James Houghton <jthoughton@google.com>
> > Signed-off-by: Anish Moorthy <amoorthy@google.com>
> > ---
> >  virt/kvm/kvm_main.c | 22 ++++++++++++----------
> >  1 file changed, 12 insertions(+), 10 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index d255964ec331e..dae5f48151032 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2479,7 +2479,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
> >  }
> >  
> >  /*
> > - * The fast path to get the writable pfn which will be stored in @pfn,
> > + * The fast path to get the pfn which will be stored in @pfn,
> >   * true indicates success, otherwise false is returned.  It's also the
> >   * only part that runs if we can in atomic context.
> >   */
> > @@ -2487,16 +2487,18 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
> >  			    bool *writable, kvm_pfn_t *pfn)
> >  {
> >  	struct page *page[1];
> > +	bool found_by_fast_gup =
> > +		get_user_page_fast_only(
> > +			addr,
> > +			/*
> > +			 * Fast pin a writable pfn only if it is a write fault request
> > +			 * or the caller allows to map a writable pfn for a read fault
> > +			 * request.
> > +			 */
> > +			(write_fault || writable) ? FOLL_WRITE : 0,
> > +			page);
> >  
> > -	/*
> > -	 * Fast pin a writable pfn only if it is a write fault request
> > -	 * or the caller allows to map a writable pfn for a read fault
> > -	 * request.
> > -	 */
> > -	if (!(write_fault || writable))
> > -		return false;
> > -
> > -	if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
> > +	if (found_by_fast_gup) {
> 
> You could have a smaller diff (and arrive at something more readable)

Heh, this whole series just screams "google3". :-)

Anish, please read through 

  Documentation/process/coding-style.rst

and 

  Documentation/process/submitting-patches.rst

particularaly the "Describe your changes" and "Style-check your changes" your
changes sections.  Bonus points if you work through the mostly redundant process/
documentation, e.g. these have supplementary info.

  Documentation/process/4.Coding.rst
  Documentation/process/5.Posting.rst
