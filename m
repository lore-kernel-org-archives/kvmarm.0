From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [Qemu-arm] [Qemu-devel] VCPU hotplug on KVM/ARM
Date: Thu, 1 Mar 2018 10:05:09 +0000
Message-ID: <CAFEAcA9yaU745Asy--jM0nu8FDJ62CEXSH_TKa-ZZfC16qye6w@mail.gmail.com>
References: <000e01d3afad$b9a13830$2ce3a890$@codeaurora.org>
 <20180227104708.GA11391@cbox>
 <ac329e1b1f5265a805916ab4f8708f9d@codeaurora.org>
 <20180227124604.GA2373@cbox>
 <20180227132131.fipafmnb56a7fj76@kamzik.brq.redhat.com>
 <20180301105030.2b716e68@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DB9842121
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 04:58:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4kVJeb60c1my for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Mar 2018 04:58:32 -0500 (EST)
Received: from mail-oi0-f53.google.com (mail-oi0-f53.google.com
 [209.85.218.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5964549E00
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 04:58:32 -0500 (EST)
Received: by mail-oi0-f53.google.com with SMTP id c18so4046606oiy.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Mar 2018 02:05:30 -0800 (PST)
In-Reply-To: <20180301105030.2b716e68@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Igor Mammedov <imammedo@redhat.com>
Cc: Christoffer Dall <cdall@cs.columbia.edu>, QEMU Developers <qemu-devel@nongnu.org>, Christoffer Dall <christofferdall@christofferdall.dk>, qemu-arm <qemu-arm@nongnu.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 1 March 2018 at 09:50, Igor Mammedov <imammedo@redhat.com> wrote:
> In QEMU on x86 (and I think ppc, s390 as well), we create vCPUs on demand.
>
> It would be nice if ARM would be able to do that too,
> so that it could take advantage of the same code.

It's not clear to me how that would work, given that for
instance the interrupt controller wants to know up-front
how many CPUs it has to deal with.

thanks
-- PMM
