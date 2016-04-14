From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 3/7] KVM: irqchip: convey devid to kvm_set_msi
Date: Thu, 14 Apr 2016 14:04:48 +0200
Message-ID: <20160414120448.GD30804@cbox>
References: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
 <1459759657-7402-4-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459759657-7402-4-git-send-email-eric.auger@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, patches@linaro.org, pbonzini@redhat.com, p.fedin@samsung.com, Manish.Jaggi@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 04, 2016 at 10:47:33AM +0200, Eric Auger wrote:
> on ARM, a devid field is populated in kvm_msi struct in case the
> flag is set to KVM_MSI_VALID_DEVID. Let's propagate both flags and
> devid field in kvm_kernel_irq_routing_entry.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
