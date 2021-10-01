Return-Path: <SRS0=fGD+=OV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C35C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 03:51:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6AFD761994
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 03:51:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6AFD761994
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9DAD4A5A0;
	Thu, 30 Sep 2021 23:51:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p5xH0mSiBK0z; Thu, 30 Sep 2021 23:51:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D19604B099;
	Thu, 30 Sep 2021 23:51:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3DAA4B08B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 23:51:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KA8wMoJRyBg9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 23:51:14 -0400 (EDT)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 233EE4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 23:51:14 -0400 (EDT)
Received: by mail-pj1-f42.google.com with SMTP id pg10so5175654pjb.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 20:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=MDJiiCfvJNK5/+V9oinRHjl1k/Y3Wr0K/+VSMV+jnd8=;
 b=NR86AkPKaehiTaJXMV/LFZjgJYQEHqqBB5nq0sO+OJ4nEEQuF0iSYeP244NpLce1BR
 u2hX4aEZf8E2x0iQWPWR8ewdENMsixmj1nuHsSEOl6GLsIZj+lzY59eoc63en+bIgOBf
 xcRMUMu7sb+WbMQArAhQepLeXgDr1gYpkWZlJ4960gFPJuOnX5gXvGn7jgD4nvSceZup
 BOo6qYLOFyprrGNeT05+G87oYllitnMcY+iqCh0PKvSr697e6lAjXIB3CO6rE1zvWVfE
 kGJlKwPfb3ponQxLaasK2FzMqXxKGeNaME01IVKMIwiHUd50zzOHrOzg4P9Z6x8DnBUZ
 u+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=MDJiiCfvJNK5/+V9oinRHjl1k/Y3Wr0K/+VSMV+jnd8=;
 b=uUc/lGBMbjwePH0S0PmMZxNFrytKjS3fvz/ARVb8KVt2XHh4m25m8IoZogG6T9rO1p
 AVhjP3FBebp5pIMhtu+c6BwS0eT6mY0KVuZaiDYf6NdlWVKbCQ19azXCoIzwTxKBVAEF
 gQ3S4EbN8kXjXDhAgxNY2U2D1dTalyAjYBTH+TjEjdiRdWVR3XCS0+9ATmUjb+wub6pg
 JhDBbc2B/yPpns79jRxJdHik/46vTQMcF+qa7bDKi7JvNsI1CToauwWbnz42xSsWJdd3
 0caA6I60RE85MniWk/l/eVWT26psTqYNpJAFmUEaW4h061RZLL4EFjGqm6G7Tk5Gbgy5
 6ixw==
X-Gm-Message-State: AOAM533JDONzdCv7LI3PHNwEf/TF1rXwJS7pRMClXT3vmXv6JUAZbiEF
 l3AL1q8iARLd3QJFAxk5Ov2ikDHlWU9ZmPRDza80lg==
X-Google-Smtp-Source: ABdhPJy3P7Ud/pDJ7IBx1wc5kDlJRJR5BQ/sfvGyHGTxat49B6SmygHHt7Fd10MN/zUAHtaaj2BvM7wtGuLIOlpemZ4=
X-Received: by 2002:a17:90a:5d11:: with SMTP id
 s17mr1209502pji.230.1633060272948; 
 Thu, 30 Sep 2021 20:51:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-2-oupton@google.com>
In-Reply-To: <20210923191610.3814698-2-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 30 Sep 2021 20:50:57 -0700
Message-ID: <CAAeT=FzwwHGtUz+0nn4HEZr80+Pw0TVA_Wc0iASPs8y1HK4g_A@mail.gmail.com>
Subject: Re: [PATCH v2 01/11] KVM: arm64: Drop unused vcpu param to
 kvm_psci_valid_affinity()
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 23, 2021 at 12:16 PM Oliver Upton <oupton@google.com> wrote:
>
> The helper function does not need a pointer to the vCPU, as it only
> consults a constant mask; drop the unused vcpu parameter.
>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
