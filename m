From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 3/5] arm: KVM: add a common vgic_queue_irq_to_lr fn
Date: Mon, 9 Mar 2015 15:47:00 +0100
Message-ID: <20150309144700.GE20559@cbox>
References: <1425302944-6276-1-git-send-email-alex.bennee@linaro.org>
 <1425302944-6276-4-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D75148201
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2015 10:40:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oaF+oe+5Gf1z for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Mar 2015 10:40:30 -0400 (EDT)
Received: from mail-la0-f51.google.com (mail-la0-f51.google.com
 [209.85.215.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 32267481BC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2015 10:40:29 -0400 (EDT)
Received: by labgm9 with SMTP id gm9so2098513lab.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Mar 2015 07:46:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1425302944-6276-4-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, open list <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 02, 2015 at 01:29:02PM +0000, Alex Benn=E9e wrote:
> This helps re-factor away some of the repetitive code and makes the code
> flow more nicely.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
