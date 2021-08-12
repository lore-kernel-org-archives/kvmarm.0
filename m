Return-Path: <SRS0=3mia=ND=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36ECBC432BE
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 09:49:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A393860FC4
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 09:49:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A393860FC4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31194407F4;
	Thu, 12 Aug 2021 05:49:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NNH1Dqi-Ie6d; Thu, 12 Aug 2021 05:49:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43EC349F8F;
	Thu, 12 Aug 2021 05:49:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 922AB4086A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 05:49:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SK06mwrj6CW8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Aug 2021 05:49:21 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F776407F4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 05:49:21 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2219360FBF;
 Thu, 12 Aug 2021 09:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628761760;
 bh=Vet1BlDXCatkjIhzZsNSd9OgVltQP2OgvncnfPQIHgk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=mgwtokDw57R1/0QIC1V3G8XhgwYX0aj5dOG8HuLi0w3RXIReDiABrTpLAHw1HtIPT
 Ui1fFOj9TfBHFEG2zN25hDzEfXgoQ9ohQpR+OMVuSfaj4eNtDbO188fx0ukxd6c7+d
 rIsA8PejX6oQz81l7+b/EMqyFfeqWQPsUiKFuofYOiry9uKdK8F2Um4NPY7QkGyjvb
 H7g8fP4HP9oEhoEjDMP8IeEoAzoatREKpApte4pKVOE5M388DITB1YU+Wv/pPDNKfv
 Wr4hLqsNQNkFJxqsQX14xjuCCAfUTmz9R1gQRQ+32v3+94RWVFLs3xh64cmSPgibWc
 mt8TPoEdJVOpg==
Date: Thu, 12 Aug 2021 10:49:14 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 06/15] KVM: arm64: Restore mdcr_el2 from vcpu
Message-ID: <20210812094914.GJ5912@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-7-tabba@google.com>
 <20210720145258.axhqog3abdvtpqhw@gator>
 <CA+EHjTweLPu+DQ8hR9kEW0LrawtaoAoXR_+HmSEZpP-XOEm2qg@mail.gmail.com>
 <20210812084600.GA5912@willie-the-truck>
 <CA+EHjTx7q+DeR2dNL9X6jLcqtr=ZZ5YN4WsnnbOUPvtQZP1dSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+EHjTx7q+DeR2dNL9X6jLcqtr=ZZ5YN4WsnnbOUPvtQZP1dSQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hey Fuad,

On Thu, Aug 12, 2021 at 11:28:50AM +0200, Fuad Tabba wrote:
> On Thu, Aug 12, 2021 at 10:46 AM Will Deacon <will@kernel.org> wrote:
> >
> > On Wed, Jul 21, 2021 at 08:37:21AM +0100, Fuad Tabba wrote:
> > > On Tue, Jul 20, 2021 at 3:53 PM Andrew Jones <drjones@redhat.com> wrote:
> > > >
> > > > On Mon, Jul 19, 2021 at 05:03:37PM +0100, Fuad Tabba wrote:
> > > > > On deactivating traps, restore the value of mdcr_el2 from the
> > > > > newly created and preserved host value vcpu context, rather than
> > > > > directly reading the hardware register.
> > > > >
> > > > > Up until and including this patch the two values are the same,
> > > > > i.e., the hardware register and the vcpu one. A future patch will
> > > > > be changing the value of mdcr_el2 on activating traps, and this
> > > > > ensures that its value will be restored.
> > > > >
> > > > > No functional change intended.
> > > >
> > > > I'm probably missing something, but I can't convince myself that the host
> > > > will end up with the same mdcr_el2 value after deactivating traps after
> > > > this patch as before. We clearly now restore whatever we had when
> > > > activating traps (presumably whatever we configured at init_el2_state
> > > > time), but is that equivalent to what we had before with the masking and
> > > > ORing that this patch drops?
> > >
> > > You're right. I thought that these were actually being initialized to
> > > the same values, but having a closer look at the code the mdcr values
> > > are not the same as pre-patch. I will fix this.
> >
> > Can you elaborate on the issue here, please? I was just looking at this
> > but aren't you now relying on __init_el2_debug to configure this, which
> > should be fine?
> 
> I *think* that it should be fine, but as Drew pointed out, the host
> does not end up with the same mdcr_el2 value after the deactivation in
> this patch as it did after deactivation before this patch. In my v4
> (not sent out yet), I have fixed it to ensure that the host does end
> up with the same value as the one before this patch. That should make
> it easier to check that there's no functional change.
> 
> I'll look into it further, and if I can convince myself that there
> aren't any issues and that this patch makes the code cleaner, I will
> add it as a separate patch instead to make reviewing easier.

Cheers. I think the new code might actually be better, as things like
MDCR_EL2.E2PB are RES0 if SPE is not implemented. The init code takes care
to set those only if if probes SPE first, whereas the code you're removing
doesn't seem to check that.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
