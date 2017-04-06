From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2 2/9] KVM: Add documentation for VCPU requests
Date: Thu, 6 Apr 2017 12:18:02 +0200
Message-ID: <985f69f3-3a4b-3742-731e-aac3a26b1777@de.ibm.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-3-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 439C040AF9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Apr 2017 06:15:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ynlhyReKPG3k for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Apr 2017 06:15:53 -0400 (EDT)
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2560240A7F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Apr 2017 06:15:52 -0400 (EDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id
 v369wrSn071110
 for <kvmarm@lists.cs.columbia.edu>; Thu, 6 Apr 2017 06:18:07 -0400
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
 by mx0b-001b2d01.pphosted.com with ESMTP id 29ndvra2ug-1
 (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Apr 2017 06:18:07 -0400
Received: from localhost
 by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <kvmarm@lists.cs.columbia.edu> from <borntraeger@de.ibm.com>;
 Thu, 6 Apr 2017 06:18:07 -0400
In-Reply-To: <20170331160658.4331-3-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, cdall@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 03/31/2017 06:06 PM, Andrew Jones wrote:
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  Documentation/virtual/kvm/vcpu-requests.rst | 114 ++++++++++++++++++++++++++++
>  1 file changed, 114 insertions(+)
>  create mode 100644 Documentation/virtual/kvm/vcpu-requests.rst
> 
> diff --git a/Documentation/virtual/kvm/vcpu-requests.rst b/Documentation/virtual/kvm/vcpu-requests.rst
> new file mode 100644
> index 000000000000..ea4a966d5c8a
> --- /dev/null
> +++ b/Documentation/virtual/kvm/vcpu-requests.rst
> @@ -0,0 +1,114 @@
> +=================
> +KVM VCPU Requests
> +=================
> +
> +Overview
> +========
> +
> +KVM supports an internal API enabling threads to request a VCPU thread to
> +perform some activity.  For example, a thread may request a VCPU to flush
> +its TLB with a VCPU request.  The API consists of only four calls::
> +
> +  /* Check if VCPU @vcpu has request @req pending. Clears the request. */
> +  bool kvm_check_request(int req, struct kvm_vcpu *vcpu);
> +
> +  /* Check if any requests are pending for VCPU @vcpu. */
> +  bool kvm_request_pending(struct kvm_vcpu *vcpu);
> +
> +  /* Make request @req of VCPU @vcpu. */
> +  void kvm_make_request(int req, struct kvm_vcpu *vcpu);
> +
> +  /* Make request @req of all VCPUs of the VM with struct kvm @kvm. */
> +  bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
> +
> +Typically a requester wants the VCPU to perform the activity as soon
> +as possible after making the request.  This means most requests,
> +kvm_make_request() calls, are followed by a call to kvm_vcpu_kick(),
> +and kvm_make_all_cpus_request() has the kicking of all VCPUs built
> +into it.
> +
> +VCPU Kicks
> +----------
> +
> +A VCPU kick does one of three things:
> +
> + 1) wakes a sleeping VCPU (which sleeps outside guest mode).
> + 2) sends an IPI to a VCPU currently in guest mode, in order to bring it
> +    out.
> + 3) nothing, when the VCPU is already outside guest mode and not sleeping.
> +
> +VCPU Request Internals
> +======================
> +
> +VCPU requests are simply bit indices of the vcpu->requests bitmap.  This
> +means general bitops[1], e.g. clear_bit(KVM_REQ_UNHALT, &vcpu->requests),
> +may also be used.  The first 8 bits are reserved for architecture
> +independent requests, all additional bits are available for architecture
> +dependent requests.
> +
> +VCPU Requests with Associated State
> +===================================
> +
> +Requesters that want the requested VCPU to handle new state need to ensure
> +the state is observable to the requested VCPU thread's CPU at the time the
> +CPU observes the request.  This means a write memory barrier should be
> +insert between the preparation of the state and the write of the VCPU
> +request bitmap.  Additionally, on the requested VCPU thread's side, a
> +corresponding read barrier should be issued after reading the request bit
> +and before proceeding to use the state associated with it.  See the kernel
> +memory barrier documentation [2].
> +
> +VCPU Requests and Guest Mode
> +============================

FWIW, s390 does not implement the guest mode. Maybe add some words that not
all architectures implement that? Or do we expect Radims rework soon?
