From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 00/13] kvm: selftests: add aarch64 framework and dirty
Date: Tue, 30 Oct 2018 18:50:11 +0100
Message-ID: <456a3ba7-09cb-0cf6-fefb-508ff422b992@redhat.com>
References: <20180918175436.19742-1-drjones@redhat.com>
 <20181029174002.GB12057@e113682-lin.lund.arm.com>
 <20181030173820.3v2czxqkeaicfqtn@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17FE94A2AE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Oct 2018 13:50:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L5PUp-Sug3zz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Oct 2018 13:50:39 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D10A4A2AC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Oct 2018 13:50:39 -0400 (EDT)
In-Reply-To: <20181030173820.3v2czxqkeaicfqtn@kamzik.brq.redhat.com>
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
To: Andrew Jones <drjones@redhat.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 30/10/2018 18:38, Andrew Jones wrote:
> There are three parts to a kvm selftest: 1) the test code which runs in
> host userspace and _is_ the kvm userspace used with kvm, 2) the vcpu
> thread code which executes KVM_RUN for the guest code and possibly also
> some host userspace test code, and 3) the guest code, which is naturally
> run in the vcpu thread, but in guest mode.

Note that the vcpu thread is a specialty of this test.  Usually it's not
needed and 1+2 are the same.

Paolo
