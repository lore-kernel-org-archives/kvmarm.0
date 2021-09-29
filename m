Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E6CC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 13:33:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C974B6142A
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 13:33:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C974B6142A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 370294B11F;
	Wed, 29 Sep 2021 09:33:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JtZvMo75ShRQ; Wed, 29 Sep 2021 09:33:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D3124B12C;
	Wed, 29 Sep 2021 09:33:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 465C44B11F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 09:33:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aK9tZrMz7qj8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 09:33:34 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 616794B11C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 09:33:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632922414;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Dp0Dog3coHxj0QgucUNcGEsig+2bXpk05DYt8z5lf/4=;
 b=KXpdxL9pEDsB5J7nAcgz2b4wGk3ZtQ8Lqn+A8UEN3s49Z0wJPailuHpiiRUHHZh+hJKTat
 iYJgMJtDqlNW/fVRo7dYm6jar5xdRc9ZrLDbKj6usyyrugiinanF8PsRo1JgtBE3dsK/g/
 k6v2dFz1pgF5fkg3rmRs6KN3UuQDXhI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-OXt1m0ehMUuS71XL86bDog-1; Wed, 29 Sep 2021 09:33:31 -0400
X-MC-Unique: OXt1m0ehMUuS71XL86bDog-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51C2B1B2C980;
 Wed, 29 Sep 2021 13:33:25 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C26219C79;
 Wed, 29 Sep 2021 13:33:24 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
 id 0A35F416CE5D; Wed, 29 Sep 2021 10:33:21 -0300 (-03)
Date: Wed, 29 Sep 2021 10:33:21 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v8 3/7] KVM: x86: Fix potential race in KVM_GET_CLOCK
Message-ID: <20210929133320.GA10977@fuller.cnet>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-4-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210916181538.968978-4-oupton@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Thu, Sep 16, 2021 at 06:15:34PM +0000, Oliver Upton wrote:
> Sean noticed that KVM_GET_CLOCK was checking kvm_arch.use_master_clock
> outside of the pvclock sync lock. This is problematic, as the clock
> value written to the user may or may not actually correspond to a stable
> TSC.
> 
> Fix the race by populating the entire kvm_clock_data structure behind
> the pvclock_gtod_sync_lock.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>

ACK patches 1-3, still reviewing the remaining ones...

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
