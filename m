From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 3/7] KVM: irqchip: convey devid to kvm_set_msi
Date: Fri, 17 Jul 2015 12:09:15 +0200
Message-ID: <55A8D44A.3030105@redhat.com>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
 <1436430137-24205-4-git-send-email-eric.auger@linaro.org>
 <01d401d0c062$086c2ee0$19448ca0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <01d401d0c062$086c2ee0$19448ca0$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, 'Eric Auger' <eric.auger@linaro.org>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu



On 17/07/2015 09:27, Pavel Fedin wrote:
>> > +	} else if (!msi->flags)
>> > +		return -EINVAL;
>  Did you mean "if (msg->flags)" here (inverted condition)?

Indeed, and also you need { } around the return for the QEMU coding
standard.

Paolo

>> > +
>> > +	/* historically the route.type was not set */
>> > +
