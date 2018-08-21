From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: Documentation: rename the capability of
 KVM_CAP_ARM_SET_SERROR_ESR
Date: Tue, 21 Aug 2018 13:06:35 +0200
Message-ID: <a1d72e58-ce94-e681-bebc-125ea84045d1@redhat.com>
References: <1534801165-41525-1-git-send-email-gengdongjiu@huawei.com>
 <20180820142925.zw2vgplbutfcvvos@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE7544A20B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Aug 2018 07:06:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PqTP4Ef9a4VB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Aug 2018 07:06:39 -0400 (EDT)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB1814A0CC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Aug 2018 07:06:39 -0400 (EDT)
Received: by mail-wm0-f67.google.com with SMTP id y2-v6so2526691wma.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Aug 2018 04:06:39 -0700 (PDT)
In-Reply-To: <20180820142925.zw2vgplbutfcvvos@kamzik.brq.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, Dongjiu Geng <gengdongjiu@huawei.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 20/08/2018 16:29, Andrew Jones wrote:
>> In the documentation description, this capability's name is
>> KVM_CAP_ARM_SET_SERROR_ESR, but in the header file this
>> capability's name is KVM_CAP_ARM_INJECT_SERROR_ESR, so change
>> the documentation description to make it same.
>> 
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>
> Reported-by: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>

Queued, thanks.

Paolo
