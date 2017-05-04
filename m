From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 08/10] KVM: arm/arm64: change exit request to sleep
 request
Date: Thu, 4 May 2017 13:38:13 +0200
Message-ID: <a53a6dfc-b5ba-f7f1-d23d-8db96d7fc3e4@redhat.com>
References: <20170503160635.21669-1-drjones@redhat.com>
 <20170503160635.21669-9-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170503160635.21669-9-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: cdall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu



On 03/05/2017 18:06, Andrew Jones wrote:
> -#define KVM_REQ_VCPU_EXIT \
> +#define KVM_REQ_SLEEP \
>  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_NO_WAKEUP | KVM_REQUEST_WAIT)


Note that this is still like this in kvm/queue:

#define KVM_REQ_VCPU_EXIT       (8 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)

but I did like the KVM_ARCH_REQ_FLAGS of Radim's series (just not
KVM_REQUEST_NO_WAKEUP_WAIT or whatever it was...).
